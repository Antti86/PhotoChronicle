# PhotoChronicle

PhotoChronicle on komentoriviltä ajettava Ruby-skripti, joka järjestelee tiedostot (esimerkiksi valokuvat) automaattisesti kansioihin tiedostojen muokkausajankohdan perusteella. Tiedostot ryhmitellään ensin vuosikansioihin, ja tarpeen mukaan kuukauden tai kvartaalin mukaan nimettyihin alikansioihin.

**Huom:** Windows-versio on saatavilla erillisenä .exe-pakettina (löytyy GitHubin *Releases*-osiosta). Se ei vaadi Ruby-asennusta.
## ☑️ Pääominaisuudet

* Toimii kaikille tiedostotyypeille, mutta `.exe`-tiedostot jätetään käsittelemättä
* Ryhmittely vuosien ja kuukausien mukaan
* Kvartaaliyhdistely: jos kvartaalissa < 15 tiedostoa, ne yhdistetään samaan kansioon
* Jos vuodessa on < 10 tiedostoa, tiedostot sijoitetaan suoraan vuosikansioon ilman alikansioita
* Tukee alikansioiden skannausta
* Siirtojen yhteenveto ajon lopuksi
* Tiedostonimien konfliktit vältetään automaattisesti (lisätään timestamp)
  

## 💻 Käyttö Windowsilla

1. Lataa `PhotoChronicle.exe` [Releases-sivulta](https://github.com/Antti86/PhotoChronicle/releases).
2. Kopioi `.exe`-tiedosto siihen kansioon, jonka tiedostot haluat järjestellä.
3. Käynnistä ohjelma kaksoisklikkaamalla tai komentoriviltä:

   ```powershell
   .\PhotoChronicle.exe
4. Tiedostot siirtyvät automaattisesti alikansioihin (vuosi/kuukausi), ja ajon lopuksi näytetään yhteenveto.
Huom: Itse PhotoChronicle.exe-tiedosto ei siirry mukana, mutta muut mahdolliset tiedostotyypit (kuten .dll) siirtyvät, ellei niitä erikseen estetty.


## 🚀 Käyttö Linuxilla

1. Varmista, että järjestelmässäsi on Ruby asennettuna:

   ```bash
   ruby -v
   ```

   Jos Ruby ei ole asennettu:

   ```bash
   sudo apt install ruby-full
   ```

2. Kloonaa projekti:

   ```bash
   git clone https://github.com/Antti86/PhotoChronicle.git
   cd PhotoChronicle
   ```

3. Siirrä tai kopioi kaikki järjesteltävät tiedostot projektikansion juureen. Varmista, ettei kansiossa ole ohjelmatiedostoja tai muuta, mitä ei haluta järjesteltäväksi.
.exe-tiedostot ohitetaan automaattisesti, mutta esimerkiksi .dll-tiedostot siirtyvät mukaan.

4. Aja skripti:

   ```bash
   ruby PhotoChronicle.rb
   ```

## ⚖️ Lisäasetukset (muokkaa skriptin alkuun):

```ruby
dry_run = true        # jos true, käyttää "testiajo", ei tee muutoksia
print_all_files = true # jos true, tulostaa kaikki siirrettävät tiedostot
```

## 📅 Kansiologiikka

* Esimerkki kansiorakenteesta:

  ```
  2022/
    Tammikuu/kuva1.jpg
    Helmikuu/kuva2.jpg
  2023/
    Tammikuu-Maaliskuu/
      kuva3.jpg
  ```

## 🚫 Poissuljetut kohteet

Skripti ohittaa automaattisesti seuraavat:

* Itse skriptitiedoston (`PhotoChronicle.rb`)
* .exe-tiedostot
* .git/, .vscode/, .gitignore
* Kansiot, joiden nimi on nelinumeroinen vuosiluku (esim. `2023/`)

## 🔄 Mahdollisia tulevia parannuksia

* Tuettujen tiedostotyyppien suodatus parametrillisesti
* Kynnysarvon määritys komentoriviltä (esim. tiedostojen määrä per kvartaalikansio)
* Undo-toiminto tai lokitiedosto
* Englanninkielinen versio
---


