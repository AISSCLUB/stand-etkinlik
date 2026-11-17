-- Run in the intended project's SQL editor. Creates only stand_* tables.
-- Contact details and results are write-only to visitors. No public staff/admin page.
begin;
create table if not exists public.stand_contacts (
 id uuid primary key,
 full_name text not null check (char_length(trim(full_name)) between 1 and 100),
 email text not null check (char_length(email) between 3 and 254 and email ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'),
 department text check (char_length(department) <= 120),
 locale text not null check (locale in ('tr','en','ar')),
 consent_version text not null check (consent_version = '2026-11-18-v1'),
 created_at timestamptz not null default now()
);
create table if not exists public.stand_ideas (
 id uuid primary key,
 body text not null check (char_length(trim(body)) between 5 and 600),
 locale text not null check (locale in ('tr','en','ar')),
 approved boolean not null default false,
 consent_version text not null check (consent_version = '2026-11-18-v1'),
 created_at timestamptz not null default now()
);
create table if not exists public.stand_results (
 id uuid primary key,
 kind text not null check (kind in ('test','coding','mission')),
 programming_language text check (programming_language in ('C','Python','C++','C#','Java')),
 score integer check (score between 0 and 5),
 mission_id integer check (mission_id between 1 and 7),
 result_text text check (char_length(trim(result_text)) between 1 and 3000),
 locale text not null check (locale in ('tr','en','ar')),
 consent_version text not null check (consent_version = '2026-11-18-v1'),
 created_at timestamptz not null default now(),
 check ((kind in ('test','coding') and programming_language is not null and score is not null and mission_id is null and result_text is null)
     or (kind = 'mission' and mission_id is not null and result_text is not null and programming_language is null and score is null))
);
alter table public.stand_contacts enable row level security;
alter table public.stand_ideas enable row level security;
alter table public.stand_results enable row level security;
revoke all on public.stand_contacts, public.stand_ideas, public.stand_results from anon, authenticated;
grant insert (id,full_name,email,department,locale,consent_version) on public.stand_contacts to anon;
grant insert (id,body,locale,consent_version) on public.stand_ideas to anon;
grant select (id,body,created_at) on public.stand_ideas to anon;
grant insert (id,kind,programming_language,score,mission_id,result_text,locale,consent_version) on public.stand_results to anon;
drop policy if exists stand_contact_submit on public.stand_contacts;
create policy stand_contact_submit on public.stand_contacts for insert to anon with check (consent_version = '2026-11-18-v1');
drop policy if exists stand_idea_submit on public.stand_ideas;
create policy stand_idea_submit on public.stand_ideas for insert to anon with check (approved = false and consent_version = '2026-11-18-v1');
drop policy if exists stand_idea_read on public.stand_ideas;
create policy stand_idea_read on public.stand_ideas for select to anon using (approved = true);
drop policy if exists stand_result_submit on public.stand_results;
create policy stand_result_submit on public.stand_results for insert to anon with check (consent_version = '2026-11-18-v1');
commit;
-- Approve ideas using Supabase Table Editor (trusted project team), never the public page.
-- No authenticated policies are provided: do not reuse a separate signed-in app's tokens here.
