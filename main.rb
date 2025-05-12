require 'date'
require 'fileutils'

def siirra_tiedosto(tiedosto, kohdekansio, testi_ajo)
  return if testi_ajo

  FileUtils.mkdir_p(kohdekansio)

  kohdepolku = File.join(kohdekansio, tiedosto)
  if File.exist?(kohdepolku)
    base = File.basename(tiedosto, ".*")
    ext = File.extname(tiedosto)
    uusi_nimi = "#{base}_#{Time.now.to_i}#{ext}"
    kohdepolku = File.join(kohdekansio, uusi_nimi)
  end

  FileUtils.mv(tiedosto, kohdepolku)
end

def tulosta_tiedosto_nimet(tiedostot, tulosta_kaikki_tiedostot)
  return unless tulosta_kaikki_tiedostot
  tiedostot.each { |t| puts "    #{t}" }
end


testi_ajo = false
tulosta_kaikki_tiedostot = false

kuukaudet_nimi = ["Tammikuu", "Helmikuu", "Maaliskuu", "Huhtikuu", "Toukokuu", "Kesäkuu",
                 "Heinäkuu", "Elokuu", "Syyskuu", "Lokakuu", "Marraskuu", "Joulukuu"]

kvartaali = ["Tammikuu-Maaliskuu", "Huhtikuu-Kesäkuu", "Heinäkuu-Syyskuu", "Lokakuu-Joulukuu"]
tiedostot_per_vuosi_kk = Hash.new { |h, y| h[y] = Hash.new { |k, m| k[m] = [] } }

#Hakee kaikki tiedostot skripti kansiosta.
skriptin_nimi = File.basename($0)
Dir.glob("*").select { |f| File.file?(f) && f != skriptin_nimi }.each do |tiedosto|
  aika = File.mtime(tiedosto)
  vuosi = aika.year
  kuukausi = aika.month
  tiedostot_per_vuosi_kk[vuosi][kuukausi] << tiedosto
end

tiedostot_per_vuosi_kk.each do |vuosi, kk_hash|
  puts "Vuosi #{vuosi}:"
  
  # Lasketaan koko vuoden tiedostojen määrä
  vuoden_tiedostot = kk_hash.values.flatten
  if vuoden_tiedostot.size < 10
    puts "  (alle 10 tiedostoa – sijoitetaan suoraan #{vuosi}/ kansioon)"
      vuoden_tiedostot.each do |tiedosto|
        siirra_tiedosto(tiedosto, vuosi.to_s, testi_ajo)
      end
    tulosta_tiedosto_nimet(vuoden_tiedostot, tulosta_kaikki_tiedostot)
    next
  end

  kvartaali_map = {
    0 => (1..3).to_a,
    1 => (4..6).to_a,
    2 => (7..9).to_a,
    3 => (10..12).to_a
  }
  kvartaali_map.each do |i, kuukaudet|
    ryhma = kuukaudet & kk_hash.keys  # Vain ne kuukaudet, joita on datassa
    next if ryhma.empty?
  
    kaikki_tiedostot = ryhma.flat_map { |kk| kk_hash[kk] }
  
    if kaikki_tiedostot.size < 15
      puts "  #{kvartaali[i]}: #{kaikki_tiedostot.size} tiedostoa (→ yhdistetty kansio)"
      tulosta_tiedosto_nimet(kaikki_tiedostot, tulosta_kaikki_tiedostot)
      kaikki_tiedostot.each do |tiedosto|
        siirra_tiedosto(tiedosto, File.join(vuosi.to_s, kvartaali[i]), testi_ajo)
      end
    else
      ryhma.each do |kk|
        tiedostot = kk_hash[kk]
        next if tiedostot.empty?
        puts "  #{kuukaudet_nimi[kk - 1]}: #{tiedostot.size} tiedostoa"
        tulosta_tiedosto_nimet(tiedostot, tulosta_kaikki_tiedostot)
        tiedostot.each do |tiedosto|
          siirra_tiedosto(tiedosto, File.join(vuosi.to_s, kuukaudet_nimi[kk - 1]), testi_ajo)
        end
      end
    end
  end  
end


