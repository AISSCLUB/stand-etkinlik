# AISS Club — Dark Edition + Stand Console

Üsküdar Üniversitesi AI & Smart Systems Club interaktif stant sitesi. TR / EN / AR, bağımlılıksız statik dağıtım, Supabase veri kaydı ve yetkili görevli paneli.

## Yerel çalışma

Node.js 18+ ve isteğe bağlı Python ile proje klasöründe:

```powershell
npm.cmd test
npm.cmd run build
py -m http.server 8080 --directory dist
```

Ziyaretçi sitesi: http://localhost:8080
Görevli paneli: http://localhost:8080/admin.html

`npm install` gerekmez. Fonts ve görseller yereldir. Kaynak değişince `npm.cmd run build` yeniden çalıştırılmalıdır.

## Vercel — mevcut repo düzeni

| Alan | Değer |
| --- | --- |
| Repository | AISSCLUB/stand-etkinlik |
| Root Directory | kul-stand |
| Framework | Other |
| Build Command | node build.mjs |
| Output Directory | dist |
| Install Command | boş |

`vercel.json` bu ayarları içerir. Bu teslimde commit/push veya production deployment yapılmadı. Düzenleme başlangıcı: `b650a660f6a2b7052d301dcb82a44bf1160b3482`.

## Görsel yenileme

- Kömür siyahı yüzeyler, sınırlı sarı/yeşil vurgu, büyük editoryal başlıklar.
- Orijinal geometrik SVG, bağlantı çizgileri, imlece tepki, kart etkileşimleri, kaydırmada görünür olma ve yumuşak sayfa girişleri.
- Başlangıç, Code Challenge, AI Mission, fikir panosu, kayıt, mobil menü, footer ve admin giriş/panel ekranları aynı tasarım sisteminde.
- Sistem hareket azaltma tercihi ve kullanıcı için hareket durdurma düğmesi.
- Manrope, Space Grotesk, Noto Sans Arabic yerel font dosyaları; OFL lisansları `assets/fonts/` içinde.
- Gerçek kulüp logosu korunur. Uydurma katılımcı, istatistik veya kulüp fotoğrafı yoktur.

İlham kaynakları (yerleşim ve etkileşim yaklaşımı; tasarım/görsel kopyası değildir):
https://namethatui.com/styles
https://namethatui.com/
https://recent.design/i/1of4fz4-dirt
https://recent.design/i/o635a0e-research-lab-brand-identity

## Ziyaretçi özellikleri

- 5 mini test / 5 kolay kod tamamlama, birbirinden bağımsız.
- C, Python, C++, C#, Java; dil ve mod skorları ayrıdır.
- Boşluk / son noktalı virgül toleransı ve sınırlı eşdeğer yanıtlar. Kod çalıştırılmaz veya derlenmez.
- 7 AI Mission, 2 dakika önerilen süre, duraklatma, devam, prompt kopyalama ve sonuç paylaşımı.
- Onaydan sonra yayımlanan isimsiz fikirler.
- e-SKS bağlantısı ve gerçek QR. Resmî üyelik / otomatik üniversite veri aktarımı yapılmaz.
- İsteğe bağlı iletişim onayı ile ad, e-posta ve bölüm kaydı.
- Sonuç paylaşımından sonra görevliye gösterilecek 8 karakterlik kayıt numarası.
- Sonraki katılımcı düğmesi cevapları ve metinleri temizler. Ziyaretçi sonuçları sayfa belleğindedir; yenileme ile silinir. Dil/hareket tercihleri dışında kalıcı tarayıcı verisi tutulmaz.

## Supabase

Organizasyon: **AISSCLUB's Org2**
Proje: **AISS Stand**
Referans: `kwjdotstwoneobofqtqv`
API: https://kwjdotstwoneobofqtqv.supabase.co

`config.js` sadece public publishable anahtar içerir. Secret/service_role anahtarı yoktur.
Mevcut projeye `schema.sql` ve `admin.sql` uygulandı. Mevcut kulüp projesine dokunulmadı.

Yeni bir projeye kuruluyorsa önce `supabase/schema.sql`, sonra `supabase/admin.sql` uygulanır. Admin kurulumu sonrası eski `schema.sql` dosyasını tek başına tekrar çalıştırmayın; bu dosya authenticated yetkilerini sıfırlar.

| Veri | Ziyaretçi | Yetkili görevli |
| --- | --- | --- |
| stand_contacts | Ekleme | Okuma, sayfalama, arama, sayfa CSV |
| stand_results | Ekleme | Okuma, kayıt numarası ile bulma |
| stand_ideas | Ekleme; sadece yayımlanmış fikirleri okuma | Okuma; sadece approved alanını güncelleme |
| stand_gifts | Erişim yok | Okuma; sonuç başına tek teslim kaydı |
| stand_private.staff | Erişim yok | Doğrudan erişim yok; proje sahibi yönetir |

## İlk görevli hesabı — henüz atanmadı

Projedeki Auth kullanıcı sayısı kurulum sırasında **0** idi. Gerçek bir kişinin hesabı veya şifresi tahmin edilmedi; varsayılan admin şifresi oluşturulmadı.

1. Supabase Dashboard → AISS Stand → Authentication → Users → Add user yoluyla gerçek görevli kullanıcısını oluşturun. Şifreyi kullanıcı belirlesin; kod veya GitHub içine koymayın.
2. Proje sahibi SQL Editor’da aşağıdaki komutu gerçek e-posta ve ad ile çalıştırsın:

```sql
insert into stand_private.staff(user_id, display_name)
select id, 'Görevli Adı'
from auth.users
where lower(email) = lower('GOREVLININ_EMAIL_ADRESI')
on conflict(user_id) do update
set display_name = excluded.display_name;
```

3. Sonuçta bir satır oluştuğunu kontrol edin. Görevli `admin.html` üzerinden kendi e-posta/şifresiyle giriş yapar. Kayıtlı olmak tek başına yetki vermez; allowlist kaydı da gerekir.
4. Yetki iptali için sadece ilgili `stand_private.staff` kaydını kaldırın. Yetki her veri isteğinde veritabanından kontrol edilir; JWT içinde düzenlenebilir kullanıcı metadatasına güvenilmez.

## Panelin işlevleri

- Gerçek kayıtlardan hesaplanan sayılar, son sonuçlar ve fikir kuyruğu.
- 25 satırlık sunucu sayfalaması; iletişimde ad/e-posta araması.
- Açık onay penceresiyle fikir yayımlama / yayından kaldırma.
- Etkinlik sonucuna göre hediye teslimi. Sonuç UUID’si primary key olduğu için aynı kayıt ikinci kez teslim edilemez.
- Katılımcıdan alınan kısa kayıt numarası veya tam UUID ile sonuç araması.
- CSV indirme yalnızca görünen iletişim sayfasını kapsar; formül enjeksiyonuna karşı değerler korunur.
- 30 saniyede bir yenileme; form yazılırken veya onay penceresi açıkken otomatik yenileme bekler.
- Oturum tokenları sadece bellekte. Sayfa yenileme sonrası tekrar giriş gerekir. 15 dakika hareketsizlikte otomatik çıkış. Çıkışta özel veriler ekrandan hemen temizlenir.

Hediye sistemi kişi/kimlik/üyelik doğrulaması yapmaz. Kayıtlar isimsizdir; aynı kişinin farklı sonuçlarını birleştirmez. Skor tarayıcıdan geldiğinden resmî değerlendirme kanıtı olarak kullanılmaz.

## Doğrulama ve sınırlar

- `npm.cmd test`: **13 test başarılı.** Sorular, toleranslı cevap kontrolü, 3 dil anahtarları, yazma/retry hataları, görevli olmayan hesabın reddi, kullanıcı JWT kullanımı, refresh/logout yarışı, UUID filtreleme, HTML kaçışı ve CSV formül koruması.
- `npm.cmd run build`: başarılı.
- Tarayıcıda ana sayfa, Code Challenge, AI Mission, fikir panosu, iletişim/e-SKS ve gerçek admin giriş ekranı kontrol edildi. C yanıtı, TR/EN/AR geçişi, RTL ve hareket kontrolü denendi.
- Yaklaşık **1348, 539, 337 CSS piksel** genişliklerde görüntülendi. Küçük ekranlar tarayıcı zoom’u ile kontrol edildi; fiziksel telefon testi yapılmadı. Dış sayfa taşması gözlenmedi.
- Yeni arayüzden gerçek Supabase’ye AI Mission sonucu gönderildi; kayıt numarası alındı, SQL ile doğrulandı. Yalnızca bu test kaydı silindi.
- Gerçek DB’de authenticated ama allowlist dışı bir kullanıcı bağlamında panel erişimi `false`, özel tabloların okunabilir kayıt sayısı `0` olarak doğrulandı.
- Supabase security advisor: bulgu yok.
- Panel içi moderasyon ve hediye etkileşimleri **açıkça QA olarak işaretlenmiş, ağa bağlanmayan geçici fixture** ile tarayıcıda denendi. Fixture dağıtıma dahil değildir. Yetkili gerçek kullanıcı henüz oluşturulmadığı için canlı görevli girişi / moderasyon / hediye yazma testi ilk hesabın atanmasını bekler.

## بالعربي

أُعيد تصميم جميع الواجهات بطابع داكن، مع خطوط محلية وحركات مدروسة ودعم الهاتف والعربية. لوحة الإدارة موجودة في `admin.html` وتعرض طلبات التواصل والأفكار والنتائج وتسليم الهدايا. تم تطبيق صلاحياتها في مشروع النادي الجديد.

**المتبقي للتفعيل:** إنشاء حساب الموظف في Supabase Auth وإضافة UUID الخاص به إلى جدول `stand_private.staff` بالأمر أعلاه. لا يوجد حساب افتراضي ولا كلمة مرور موحدة. لا ترسل كلمة المرور بالمحادثة.

فك ضغط النسخة الجديدة وانسخ محتويات `kul-stand` إلى نفس المجلد داخل الريبو المحلي، ثم ارفع التعديلات من جهازك. إعداد Root Directory في Vercel يبقى `kul-stand`.
