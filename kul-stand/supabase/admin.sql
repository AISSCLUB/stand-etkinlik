-- AISS Stand staff portal. Does not grant any person staff access automatically.
begin;
create schema if not exists stand_private;
revoke all on schema stand_private from public, anon;
grant usage on schema stand_private to authenticated;
create table if not exists stand_private.staff (
 user_id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null check (char_length(trim(display_name)) between 1 and 100),
 created_at timestamptz not null default now()
);
alter table stand_private.staff enable row level security;
revoke all on stand_private.staff from public, anon, authenticated;
drop policy if exists staff_registry_no_direct_access on stand_private.staff;
create policy staff_registry_no_direct_access on stand_private.staff for all to authenticated using (false) with check (false);
-- The narrow privileged lookup stays outside exposed API schemas.
create or replace function stand_private.is_staff() returns boolean
language sql stable security definer set search_path = '' as $$
 select (select auth.uid()) is not null and exists (
  select 1 from stand_private.staff where user_id = (select auth.uid())
 );
$$;
revoke all on function stand_private.is_staff() from public, anon;
grant execute on function stand_private.is_staff() to authenticated;
create or replace function public.stand_staff_access() returns boolean
language sql stable security invoker set search_path = '' as $$
 select stand_private.is_staff();
$$;
revoke all on function public.stand_staff_access() from public, anon;
grant execute on function public.stand_staff_access() to authenticated;
-- Staff can inspect contacts/results, moderate ideas, and record delivery.
grant select on public.stand_contacts, public.stand_results, public.stand_ideas to authenticated;
grant update (approved) on public.stand_ideas to authenticated;
drop policy if exists staff_contact_read on public.stand_contacts;
create policy staff_contact_read on public.stand_contacts for select to authenticated using ((select stand_private.is_staff()));
drop policy if exists staff_result_read on public.stand_results;
create policy staff_result_read on public.stand_results for select to authenticated using ((select stand_private.is_staff()));
drop policy if exists staff_idea_read on public.stand_ideas;
create policy staff_idea_read on public.stand_ideas for select to authenticated using ((select stand_private.is_staff()));
drop policy if exists staff_idea_moderate on public.stand_ideas;
create policy staff_idea_moderate on public.stand_ideas for update to authenticated using ((select stand_private.is_staff())) with check ((select stand_private.is_staff()));
create table if not exists public.stand_gifts (
 result_id uuid primary key references public.stand_results(id),
 delivered_by uuid not null default auth.uid() references auth.users(id),
 delivered_at timestamptz not null default now()
);
alter table public.stand_gifts enable row level security;
revoke all on public.stand_gifts from public, anon, authenticated;
grant select on public.stand_gifts to authenticated;
grant insert (result_id) on public.stand_gifts to authenticated;
drop policy if exists staff_gift_read on public.stand_gifts;
create policy staff_gift_read on public.stand_gifts for select to authenticated using ((select stand_private.is_staff()));
drop policy if exists staff_gift_deliver on public.stand_gifts;
create policy staff_gift_deliver on public.stand_gifts for insert to authenticated with check ((select stand_private.is_staff()) and delivered_by=(select auth.uid()));
commit;
-- Provision a real user in Supabase Authentication -> Users first.
-- Then the project owner can run (replace email/name, do not put passwords in SQL):
-- insert into stand_private.staff(user_id,display_name)
-- select id,'Görevli adı' from auth.users where email='GOREVLI_EMAIL'
-- on conflict(user_id) do update set display_name=excluded.display_name;
-- To revoke staff access: delete the matching row from stand_private.staff.
