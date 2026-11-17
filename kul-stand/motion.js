(() => {
const reduced=matchMedia('(prefers-reduced-motion: reduce)');let paused=false;
try{paused=localStorage.getItem('aiss_motion_paused')==='true';}catch{}
let observer;
function refresh(){
 document.body.classList.toggle('motion-paused',paused||reduced.matches);
 document.documentElement.classList.toggle('motion-ready',!paused&&!reduced.matches&&'IntersectionObserver' in window);
 document.querySelector('#motion-toggle')?.setAttribute('aria-pressed',String(paused||reduced.matches));
 document.querySelectorAll('[data-i18n-aria]').forEach(el=>el.setAttribute('aria-label',window.LOCALES?.[document.documentElement.lang]?.[el.dataset.i18nAria]||'Menu'));
 observer?.disconnect();
 if(paused||reduced.matches||!('IntersectionObserver' in window)){document.querySelectorAll('.reveal').forEach(el=>el.classList.add('is-visible'));return;}
 observer=new IntersectionObserver(entries=>entries.forEach(e=>{if(e.isIntersecting){e.target.classList.add('is-visible');observer.unobserve(e.target);}}),{threshold:.08});
 document.querySelectorAll('.reveal').forEach(el=>observer.observe(el));
}
document.addEventListener('aiss:render',refresh);
document.addEventListener('DOMContentLoaded',()=>{document.querySelector('#motion-toggle')?.addEventListener('click',()=>{paused=!paused;try{localStorage.setItem('aiss_motion_paused',String(paused));}catch{}refresh();});refresh();});
reduced.addEventListener('change',refresh);
document.addEventListener('pointermove',e=>{if(paused||reduced.matches||e.pointerType==='touch')return;const art=document.querySelector('.signal-art');if(!art)return;const r=art.getBoundingClientRect();if(e.clientY<r.top||e.clientY>r.bottom||e.clientX<r.left||e.clientX>r.right){art.style.setProperty('--rx','0deg');art.style.setProperty('--ry','0deg');return;}art.style.setProperty('--rx',`${(e.clientY-r.top-r.height/2)/40}deg`);art.style.setProperty('--ry',`${(e.clientX-r.left-r.width/2)/40}deg`);},{passive:true});
})();
