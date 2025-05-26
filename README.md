# PhotoChronicle

PhotoChronicle on komentoriviltä ajettava Ruby-skripti, joka järjestelee tiedostot (esimerkiksi valokuvat) automaattisesti kansioihin tiedostojen muokkausajankohdan perusteella. Tiedostot ryhmitellään ensin vuosikansioihin, ja tarpeen mukaan kuukauden tai kvartaalin mukaan nimettyihin alikansioihin.

**Huom:** Windows-versio julkaistaan erikseen erillisenä .exe-pakettina. Se ei vaadi Ruby-asennusta.
## ☑️ Pääominaisuudet

* Toimii kaikille tiedostotyypeille (ei rajoitu kuviin)
* Ryhmittely vuosien ja kuukausien mukaan
* Kvartaaliyhdistely: jos kvartaalissa < 15 tiedostoa, ne yhdistetään samaan kansioon
* Jos vuodessa on < 10 tiedostoa, tiedostot sijoitetaan suoraan vuosikansioon ilman alikansioita
* Tukee alikansioiden skannausta
* Siirtojen yhteenveto ajon lopuksi
* Tiedostonimien konfliktit vältetään automaattisesti (lisätään timestamp)

## 🚀 Asennus ja käyttö (Linux)

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

3. Siirrä tai kopioi kaikki järjesteltävät tiedostot projektikansion juureen. Varmista että juuri kansiossa ei ole ohjelmia tai muita tiedostoja, mitä ei haluta järjestellä. Skripti ei suodata tällä hetkellä .exe tiedostoja.

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
* .git/, .vscode/, .gitignore
* Kansiot, joiden nimi on nelinumeroinen vuosiluku (esim. `2023/`)

## 🔄 Tulevia parannuksia (roadmap)

* Tuettujen tiedostotyyppien suodatus parametrillisesti
* Kynnysarvon määritys komentoriviltä (esim. tiedostojen määrä per kvartaalikansio)
* Undo-toiminto tai lokitiedosto

---


