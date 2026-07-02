### Introductie

Het doel van deze opdracht is om Pokémon in het wild te kunnen vangen en toe te voegen aan je collectie van Pokémon. Het ophalen en opslaan van alle Pokémon is al geregeld, evenals een basic setup voor een encounter en een battle. Jij maakt het mogelijk om een wilde Pokémon te vangen, te verslaan of juist ver van weg te vluchten. Succes!

### Start
- Clone deze app
- Run `docker compose up -d` om een MySQL database te starten
- Run `bin/rails db:create` en `bin/rails db:migrate`
- Start de terminal en run `Import::Processor.run` om alle Pokémon in te laden
- Run `bin/rails db:seed` om trainer Ash Ketchum met Pikachu als Pokémon aan te maken
- Installeer DaisyUI met npm install daisyui
- Run `bin/dev` om de server te starten

### Acceptatiecriteria
De volgende criteria zijn losse features en kunnen opeenvolgend worden geïmplementeerd. Probeer eerst een feature af te ronden, voordat met de volgende feature gestart wordt. Schrijf unit tests die bevestigen dat de functionaliteit werkt.

1. Wanneer je op Catch Pokémon in de navigatie klikt (`/encounters/new`) start een encounter met een willekeurige Pokémon
    - Elke keer als de pagina wordt geladen wordt een volstrekt willekeurige Pokémon getoond. Dit is al gebouwd
    - Zorg voor variatie in level en stats op basis van de volgende criteria:
        - Het level van de wilde Pokémon is maximaal 3 hoger of lager dan jouw sterkste Pokémon (bijvoorbeeld Pikachu)
        - Bereken de stats van de wilde Pokémon op basis van level en de `BasePokemon` stats
    - Wanneer op "Fight!" wordt geklikt wordt een battle geïnitialiseerd
    - Wanneer op “Start” wordt geklikt moet een battle worden aangemaakt tussen de trainer en de wilde Pokémon
2. Het is mogelijk om te vluchten tijdens het gevecht
    - In het gevecht is er een “Escape”-actie met een 50% slagingskans
    - Het gevecht eindigt met state `escaped` wanneer het gelukt is
3. Het is mogelijk om een wilde Pokémon tijdens een gevecht te vangen
    - In het gevecht is er een “Capture”-actie met een 50% slagingskans
    - Wanneer het vangen mislukt is er een kans van 30% dat de Pokémon vlucht
    - Het gevecht eindigt met state `captured` wanneer het gelukt is
4. Het is mogelijk om de wilde Pokémon te verslaan in een gevecht
    - De volgende regels gelden voor het gevecht:
        1. De eerste Pokémon uit de collectie van de Pokémon trainer start het gevecht
        2. Een gevecht bestaat uit meerdere rondes en in elke ronde mag de Pokémon van de trainer en de wilde Pokémon één actie (vechten, vangen of vluchten) uitvoeren
        3. Wie de ronde start wordt bepaald door de snelheid van de Pokémon
        4. Het gevecht eindigt wanneer een van de Pokémon is verslagen
    - De state wordt aangepast naar het resultaat en het is duidelijk wie gewonnen heeft

### Bonus

- Gebruik Turbo Frames of Streams (Hotwire) voor een vlotte gebruikerservaring
- Laat de slagingskans voor het vangen afhangen van de hoeveelheid HP die de Pokémon nog over heeft:
    - 0-30% HP: 80% kans
    - 31-70% HP: 40% kans
    - 71-100% HP: 20% kans
