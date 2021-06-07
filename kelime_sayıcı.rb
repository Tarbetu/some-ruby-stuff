# frozen_string_literal: true

# İçerisinde bağlaçları tutan bir liste

BAĞLAÇLAR = 'ile', 've', 'veya', 'ya da', 'yahut', 'veyahut', 'ama', 'fakat', 'lâkin', 'lakin', 'yalnız', 'ancak', 'oysa', 'oysaki', 'hâlbuki', 'ne var ki', 'çünkü', 'zira', 'de', 'da', 'ki', 'meğer', 'mademki', 'demek', 'demek ki', 'sanki', 'üstelik', 'hatta', 'yani'

# Daha önceden sınav açıklamasını "sınav_açıklaması.txt" isimli bir dosyaya yükledim.
# File.read... ile başlayan komutta dosya içeriğini okuyoruz ve split(' ') metni bir listeye çevirdim.
# Metin ve liste arasındaki fark şudur; Metin yekpare bir sisteme tutarken liste metni parçalı bir şekilde işlemeye izin verir.

metin_içeriği = File.read('sınav_açıklaması.txt').split(' ')
kelime_sayısı = 0

# Metin içerisindeki her bir kelime için;
# Eğer kelime bağlaç içinde geçiyorsa sonraki kelimeye geç
# Yok eğer geçmiyorsa kelime_sayısı değişkenini bir arttır

for kelime in metin_içeriği
  if BAĞLAÇLAR.include? kelime
    next
  end
  kelime_sayısı += 1
end

# kelime_sayısı değişkeni içerisinde ne kadar olduğunu yazar

puts "Sınav açıklamasında #{kelime_sayısı} kadar kelime vardır."

# Sevgili Türk siyaset tarihi hocası için :)
