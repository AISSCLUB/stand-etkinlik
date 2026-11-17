const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const vm=require('node:vm');
const context={window:{}};vm.createContext(context);
for(const file of ['questions.js','locales.js'])vm.runInContext(fs.readFileSync(file,'utf8'),context);
const w=context.window;
test('all five programming languages contain exactly five independent quiz and code exercises',()=>{
 assert.equal(w.CHALLENGE_LANGUAGES.length,5);
 for(const lang of w.CHALLENGE_LANGUAGES){assert.equal(w.QUESTIONS[lang].test.length,5);assert.equal(w.QUESTIONS[lang].coding.length,5);
 for(const q of w.QUESTIONS[lang].test){assert.ok(q.answer>=0&&q.answer<q.options.length);assert.ok(!q.code.includes('___'));}
 for(const q of w.QUESTIONS[lang].coding){assert.equal(q.code.split('___').length,2);for(const answer of q.accepted)assert.ok(w.checkAnswer(q,answer));}}
});
test('checker accepts whitespace, optional semicolons and alternate beginner expressions',()=>{
 const q=w.QUESTIONS.C.coding[1];assert.ok(w.checkAnswer(q,' a + b; '));assert.ok(w.checkAnswer(q,'b + a'));
 assert.ok(w.checkAnswer(w.QUESTIONS.Java.coding[3],' i < 4 ;'));
 assert.ok(w.checkAnswer(w.QUESTIONS.Python.coding[0],"'Merhaba'"));
});
test('checker preserves string contents and identifier case and rejects unsafe/incorrect answers',()=>{
 assert.equal(w.checkAnswer(w.QUESTIONS.C.coding[0],'"Mer haba"'),false);
 assert.equal(w.checkAnswer(w.QUESTIONS.C.coding[0],'"merhaba"'),false);
 assert.equal(w.checkAnswer(w.QUESTIONS.C.coding[1],'A+B'),false);
 assert.equal(w.checkAnswer(w.QUESTIONS.C.coding[1],'a-b'),false);
 assert.equal(w.checkAnswer(w.QUESTIONS.C.coding[1],'a+b;alert(1)'),false);
 assert.equal(w.checkAnswer(w.QUESTIONS.C.coding[4],'nums[1]'),false);
});
test('three complete UI dictionaries, all hints, and seven missions per locale',()=>{
 const keys=Object.keys(w.LOCALES.tr).sort();
 for(const locale of ['tr','en','ar']){assert.deepEqual(Object.keys(w.LOCALES[locale]).sort(),keys);for(const v of Object.values(w.LOCALES[locale]))assert.ok(v.length);
 assert.equal(w.MISSIONS[locale].length,7);assert.equal(w.QUESTION_TEXT[locale].titles.length,5);assert.equal(w.QUESTION_TEXT[locale].writeHints.length,5);}
});
