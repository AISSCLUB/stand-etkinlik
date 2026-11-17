import {mkdir,copyFile,cp,rm} from 'node:fs/promises';
await rm('dist',{recursive:true,force:true});
await mkdir('dist',{recursive:true});
for(const f of ['index.html','styles.css','config.js','locales.js','questions.js','app.js']) await copyFile(f,`dist/${f}`);
await cp('assets','dist/assets',{recursive:true});
// Keep old shared bookmarks working; no obsolete registration/staff mockups remain.
const routes={ho_geldiniz:'home',ho_geldiniz_masa_st:'home',ki_isel_bilgiler:'join',etkinlik_se_imi:'code',onay_ve_i_nceleme:'join',ba_ar_l:'join',g_revli_paneli_h_zl_do_rulama_hediye_teslim:'join'};
for(const [dir,route] of Object.entries(routes)) {
 await mkdir(`dist/${dir}`,{recursive:true});
 const {writeFile}=await import('node:fs/promises');
 await writeFile(`dist/${dir}/code.html`,`<!doctype html><meta charset="utf-8"><meta http-equiv="refresh" content="0;url=../index.html#${route}"><a href="../index.html#${route}">AISS Club</a>`);
}
console.log('Built dist/ — no dependencies required.');
