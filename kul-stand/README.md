# AISS Club — İnteraktif Stant / التسليم

## Hızlı başlangıç

Kurulum veya ücretli API gerekmez. `index.html` dosyasını açarak etkinlikleri deneyebilirsiniz.
Paylaşımlı kullanım / dağıtım için Node.js 18+ ile proje klasöründe:

```powershell
npm.cmd test
npm.cmd run build
py -m http.server 8080 --directory dist
```

Tarayıcı: http://localhost:8080
Python yoksa `dist` klasörünü mevcut statik sunucunuzda yayınlayın. `npm install` gerekmiyor; çalışma bağımlılığı yok.
`dist/` hazır dağıtım kopyasıdır. Kaynak dosyaları değiştirdikten sonra yeniden build alın.
Bu teslim canlı bir adrese yayımlanmadı ve herhangi bir Git deposuna commit/push yapılmadı.

## Yapılanlar

- Logo korunarak krem / koyu yeşil / sarı renklerle yeni, sade ve mobil uyumlu tasarım.
- Türkçe, English, العربية. Arapça RTL; kod blokları LTR. Dil değişiminde cevaplar korunur.
- Birbirinden bağımsız 5 çoktan seçmeli çıktı sorusu + 5 kolay kod tamamlama sorusu.
- C, Python, C++, C#, Java. Her dilin gerçek sözdizimi kullanılır; ilerleme dil ve moda göre ayrıdır.
- Kod tamamlama boşlukları ve son noktalı virgülü tolere eder; belirli eşdeğer başlangıç ifadeleri kabul edilir. Sınırsız tekrar ve ipuçları vardır.
- Genel amaçlı kod çalıştırıcısı / derleyici YOKTUR. Tam programlar yerine `___` boşluğu doldurulur. Kullanıcıya çalıştırma veya derleme iddiası gösterilmez.
- Seçili moddaki 5 soru basılabilir; cevap anahtarı `questions.js` içinde.
- 7 rastgele AI görevi, 2 dakikalık durdurulabilir sayaç, prompt kopyalama, ChatGPT bağlantısı ve sonuç alanı. Süre dolunca gönderim engellenmez.
- Fikir panosu gerçek kayıtlardan yüklenir; sahte öğrenci, oy veya başarı sayısı yoktur. Yeni fikirler onay bekler.
- e-SKS resmî bağlantısı ve o bağlantıya ait gerçek QR. Bu QR üyelik kartı veya hediye doğrulama kodu değildir.
- Sonraki katılımcı düğmesi mevcut oturumun cevaplarını ve metinlerini temizler. İlerleme yalnızca bellekte tutulur; sayfa yenilenince silinir. Yalnızca dil tercihi localStorage’a yazılır.
- Önceki sahte üye/QR/görevli ekranları dağıtımda ilgili yeni sayfalara yönlenir. Gerçek personel kimlik doğrulaması olmadan açık yönetici ekranı sunulmaz.

## Supabase bağlantısı — canlı bağlantı hazır

AISSCLUB's Org2 içinde yeni **AISS Stand** projesi oluşturuldu; mevcut kulüp projesi değiştirilmedi.

- Proje referansı: `kwjdotstwoneobofqtqv`
- Bölge: `eu-central-1`
- API adresi: https://kwjdotstwoneobofqtqv.supabase.co
- `config.js` yeni projenin public publishable anahtarına bağlıdır. Secret / service_role anahtarı kullanılmaz.
- SQL şeması uygulandı; üç tabloda RLS açık. İletişim, fikir ve sonuç ekleme gerçek API üzerinden doğrulandı.
- İletişim formunda isim/e-posta kullanım amacı ve açık onay bulunur. Onaylı kurumsal aydınlatma metni varsa `privacyUrl` alanına eklenebilir.
- `vercel.json` hazır. Vercel yayını AISS hesabına giriş beklediğinden **henüz yapılmadı**. InternMatch hesabında proje oluşturulmadı.
- Vercel ayarları: Framework Other, Build Command `node build.mjs`, Output Directory `dist`, Install Command boş.
- `clubWebsite` ve `instagramUrl` alanları gerçek hesaplar sağlanana kadar boş tutulur.

Veriler:

| Tablo | İçerik | Ziyaretçi yetkisi |
| --- | --- | --- |
| stand_contacts | Ad, e-posta, isteğe bağlı bölüm, dil, onay sürümü | Yalnızca ekleme; okuma/güncelleme/silme yok |
| stand_ideas | Fikir, dil, moderasyon durumu, onay sürümü | Ekleme; yalnızca onaylı fikir metinleri okunur |
| stand_results | İsimsiz test/kod sonucu veya AI görevi çıktısı | Yalnızca ekleme; sonuçları okuma yok |

Her gönderim açık bir onay kutusu gerektirir. Soru ve görev sonuçlarını paylaşmak isteğe bağlıdır.
İletişim talebi, e-SKS üyeliğinden ayrıdır. İsim/e-posta bilgisi fikir panosuna eklenmez.
Onay ve tarih alanları sunucuda kısıtlanır. Rastgele UUID, tekrar gönderimde aynı kaydın çoğalmasını önler. Yazma işlemi SELECT gerektirmeyen normal INSERT kullanır; yalnızca aynı birincil anahtarın tekrar gönderimi başarıyla kabul edilir.
Skorlar tarayıcıdan gelir; ödül, resmî değerlendirme veya kimlik kanıtı için güvenilir sayılmamalıdır.
Bu stant akışında herkese açık ekleme vardır. İnternette geniş kullanım öncesi sunucu tarafı hız sınırlama / kötüye kullanım önlemlerini ayrıca değerlendirin.

### Fikir onayı ve verileri görme

Yetkili ekip Supabase Table Editor’dan kayıtları görür. İncelenen fikir için `approved=true` yapılınca fikir panosunda görünür. `created_at` ve kişisel bilgiler ziyaretçiler tarafından değiştirilemez.
Bu teslim kullanıcı hesabı, personel paneli, rol yönetimi veya otomatik hediye dağıtım sistemi kurmaz.

### Canlı bağlantı sonrası kabul kontrolü

1. Test bir fikir gönderin; onaylanmadan panoda görünmediğini kontrol edin.
2. Table Editor’da onaylayın, panoyu yenileyin: fikir görünmeli, HTML metin olarak gösterilmeli.
3. Test iletişim talebi gönderin; Table Editor’da görünmeli. Publishable anahtarla contact/result tablolarını okumayı deneyince izin verilmemeli.
4. 5 soruyu tamamlayın ve onay vererek sonucu paylaşın; yalnızca bir sonuç satırı oluşmalı.
5. Ağ kapalıyken gönderin: başarı yerine hata görünmeli ve yazılan metin korunmalı.
6. Paylaşımlı cihazda “Sıradaki katılımcı” ile cevapların/metinlerin temizlendiğini kontrol edin.

## e-SKS

Doğrulanan genel giriş: https://e-sks.uskudar.edu.tr/
Üniversitenin platform tanıtımı: https://sks.uskudar.edu.tr/sks-dijital-platformlari
Öğrenci kulübü modülü tanıtımı: https://uskudar.edu.tr/etkinlik/e-sks-sistemi-sosyal-transkript-modulu-ve-ogrenci-kulupleri-modulu/9303

Buton öğrenciyi e-SKS’ye yönlendirir. Öğrenci üniversite hesabıyla giriş yapıp kulübü seçer. Otomatik veri aktarımı, otomatik üyelik veya bu sistemden kayıt onayı ALINMAZ. Böyle bir entegrasyon için SKS’nin sağladığı ve izin verdiği bir API / kulübe özel bağlantı gerekir.
`config.js` içindeki `sksUrl` değiştirilirse `assets/e-sks-qr.png` hâlâ genel e-SKS girişine gider; kulübe özel QR istenirse bu görsel de yeniden oluşturulmalıdır.

## Doğrulama

`npm.cmd test`: 7 otomatik test başarılı: 5 dil × 2 mod × 5 soru yapısı, kabul edilen ifadeler, hatalı / zararlı cevaplar ve 3 dilde anahtar/görev bütünlüğü.
`npm.cmd run build`: başarılı.
Tarayıcıda: C’de 5 kod sorusu tamamlandı; test modunun skoru bağımsız kaldı. Python yanıtı, TR/EN/AR geçişi, RTL, AI görevi, sayaç ve e-SKS/QR ekranı denendi. Canlı Supabase API üzerinden contact/idea/result kayıtları oluşturuldu ve SQL ile doğrulandı. Tekrar gönderim, özel verilerin anonim okunamaması, onaysız fikrin gizlenmesi ve geçersiz skorun reddedilmesi test edildi. Sadece bu testlerde oluşturulan kayıtlar silindi; üç tablo da boş bırakıldı. Güvenlik danışmanında bulgu yok. Onaylanmış bir fikrin kamuya yayınlanması testi otomatik onay incelemesi tarafından reddedildiği için yapılmadı. Mobil kırılım CSS’i hazır; gerçek mobil cihaz testi yapılmadı.

Supabase resmî kaynaklar:
https://supabase.com/docs/guides/api/creating-routes
https://supabase.com/docs/guides/database/postgres/row-level-security
https://supabase.com/docs/guides/getting-started/api-keys

## بالعربي

المشروع جاهز محلياً للتجربة ومعه نسخة `dist` جاهزة للاستضافة الثابتة. التصميم واللغات والأسئلة والمهام ولوحة الأفكار ومسار التسجيل تم تنفيذها. افتح `index.html` أو شغّل الأوامر أعلاه.

تم إنشاء مشروع AISS Stand جديد داخل منظمة النادي وربطه فعلياً. جرى التحقق من الحفظ والصلاحيات وحذف بيانات الاختبار. النشر على Vercel ما زال ينتظر دخول حساب AISS؛ إعدادات النشر مرفقة في vercel.json. لا حاجة لإرسال أي مفتاح سري.

رابط وQR التسجيل يفتحان e-SKS الرسمي؛ نقل البيانات تلقائياً إلى الجامعة يحتاج تكاملاً توفره SKS. تم إعداد ملف `PROMPT_REVISED_TR.md` وفيه المتطلبات المصحّحة لصاحب المشروع.
