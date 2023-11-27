# Eksamen PGR301 2023

Candidate Nr: 2011

## Oppgave 1. Kjell's Python kode
### A. SAM & GitHub actions workflow
For å kjøre [python-deploy.yml](.github/workflows/python-deploy.yml) må du legge in IAM key og IAM secret key fra AWS brukeren din på GitHub secrets. Du kan også eventuelt bytte ut --s3-bucket pgr301-sam-bucket meg egen bucket for å kjøre scriptet

For å teste applikasjonen etter den kjører kan du bruke kommandoene under. Du kan bytte ut BUCKET_NAME med navnet på din egen bucket, men kan godt bruke min. Men du må bytte ut *** med dine egne keys
* docker run -p 8080:8080 -e AWS_ACCESS_KEY_ID=*** -e AWS_SECRET_ACCESS_KEY=*** -e BUCKET_NAME=simbucket2011 ppe
* docker run -e AWS_ACCESS_KEY_ID=***  -e AWS_SECRET_ACCESS_KEY=***  -e BUCKET_NAME=simbucket2011 kjellpy


## Oppgave 3. Terraform, AWS Apprunner og Infrastruktur som kode
### B. Terraform i GitHub Actions
For å kjøre [java-deploy.yml](.github/workflows/java-deploy.yml) må du legge in IAM key og IAM secret key fra AWS brukeren din på GitHub secrets, med mindre du allerede gjorde det for Python scriptet. 

I [java-deploy.yml](.github/workflows/java-deploy.yml) må du også bytte ut mama014-private med din egen ecr repository i IMAGE: 244530008913.dkr.ecr.eu-west-1.amazonaws.com/mama014-private:latest og bytte ut ALARM_EMAIL med din egen mail

Du kan teste applikasjonen med å kjøre curl kommandoen under for å teste applikasjonen som kjører på mitt domene/apprunner
* curl -X GET "https://dx27uij3b5.eu-west-1.awsapprunner.com/scan-ppe?bucketName=simbucket2011"

Eller, du kan kjøre kommandoen under når du tester lokalt
* curl http://localhost:8080/scan-ppe?bucketName=simbucket2011

## Oppgave 4. Feedback
### A. Utvid applikasjonen og legg inn "Måleinstrumenter"

Det føltes naturlig å registrere hvor mange som brøt de forksjellige PPE reglene. Så jeg lagde en counter for hver type, og en som målte totale violations mellom alle.
Dette vil gi bedriften informasjon om hvor mange som bryter reglene om utstyr.
Koblet til dette, valgte jeg å måle en prosent av hvor mange av bildene hvor det var regelbrudd. 

Jeg valgte også å måle latancy på de forskjellige funksjonene, da kan man måle om det er tider av dagen hvor ting sinkes, og man kan se om man ønsker å gi applikasjonen mer resurser så den kjører mer effektivt.

Jeg måler også antall personer som er på bildet, dette kunne bli brukt av en bedrift til å se hvor mange ansatte er på jobb til enhver tid. 


### B. CloudWatch Alarm og Terraform moduler
Jeg valge å lage alarmer for latancy på de forskjellige endpointene, da kan man se om man se om kanskje noe er galt, slik at man evt. kan spinne opp flerer services for å takle det. 

Jeg måler også hvor mange som bryter ppe reglene, både på antall og prosent. Jeg har kun laget alarm for hoved /scan-ppe, men denne kan utvides til de andre også. Her kan man da raskt se om det er for mange uten maske. Prosent er bra uansett, men med veldig store antall personer kan det også være fint å ha en tall grense på hvor mange man aksepterer uten utstyr. 

## Oppgave 5. Drøfteoppgaver
### A. Kontinuerlig Integrering
- En definisjon av kontinuerlig integrasjon.

Kontinuerlig integrasjon er et software-prinsipp der man kontinuerlig integrerer koden man utvikler inn i hoved branchen, samt at koden deployes i production. Dette gjøres via automatiserte prosesser som f.eks. GitHub Actions.

- Fordelene med å bruke CI i et utviklingsprosjekt - hvordan CI kan forbedre kodekvaliteten og effektivisere utviklingsprosessen.

Siden CI gjør automatisk bygg og testing ofte så vil man oppdage feil og bugs raskere. Man vil også ha en mye raskere utviklingssyklus, da man går raskt fra development, til testing, til at koden går ut i produksjons miljøet. Fordi man også integrerer ofte, vil man få færre feil når det gjelder integrasjon og konflikter. CI gjør også samarbeid mellom utviklere lettere ved å sikre at endringer i koden integreres jevnlig, som gjør at man kan bygge videre på hverandres arbeid og se hva andre gjør lettere. CI gir også muligheten til å automatisere byggeprosessen og testing noe som frigjør utviklernes tid og reduserer manuell innsats.

- Hvordan jobber vi med CI i GitHub rent praktisk? For eskempel i et utviklingsteam på fire/fem utivklere?

Man kan da jobbe på hver sin branch, hvor man kjører GitHub Actions på pull-requests mot main får å verifisere at koden vil fungere på main branches. Man kan også da trekke andre sine pushes inn på egne branches for å kunne ta i bruks deres arbeid på det man jobber på. Man vil raskt kunne fikse ting hvis det går galt, og grunnet versjonskontroll kan man lettere se hva endringene som ble gjort var.
### B. Sammenligning av Scrum/Smidig og DevOps fra et Utviklers Perspektiv
1. **Scrum/Smidig Metodikk:**

Scrum er en smidig metodikk som benyttes i utvikling for å organisere og håndtere komplekse prosjekter. Man har definerte roller som Scrum Master, Product Owner, og utviklingsteam, og jobber i iterative perioder kalt sprinter som varer et par uker. Scrum fremmer samarbeid mellom teammedlemmer og kunder gjennom daglige scrum-møter og sprint-reviews. Dette gir fleksibilitet, rask tilpasningsmuligheter og tidlig leveranse av funksjonalitet. Utfordringer i Scrum kan oppstå når team ikke overholder strukturen eller når kravene endres ofte. Det kan også være at man i Scrum kun pusher til produksjon på slutten av hver sprint, som betyr at hvis man har lengre sprinter, så pusher man ikke kode så ofte, som betyr at feil kan bli større og vanskeligere å fikse.

2. **DevOps Metodikk:**

DevOps er en metodikk som fokuserer på å kombinere utvikling- og driftsaktiviteten for å oppnå kontinuerlig leveranse av kode. En del av de sentrale prinsippene er automatisering, samarbeid og overvåking. Via automatisering gjør man bygging, testing, og deplyoment, noe som bidrar til raskere leveranse og kvalitetssikring. Fordi man ofte pusher til main/produksjon så vil man bli klar over feil fort, og kan raskt finne grunnårsaken og fikse det. Kvaliteten på koden vil dermed bli bedre, samtidig som man kan sende ut ny kode raskt og hyppig vie automatiseringen. Styrker ved DevOps er økt effektivitet, redusert tide fra development til koden er i produksjonsmiljøet og forbedret samarbeid. Utfordringer kan oppstå når det gjelder å implementere kulturendringer, håndtere komplekse automatiseringsverktøy og opprettholde sikkerhet.

3. **Sammenligning og Kontrast:**

Både Scrum og DevOps har forskjellige styrker og svakheter. Scrum legger mer vekt på strukturerte sprinter og samarbeid, som gir fleksibilitet og tidlig leveranse av kode. Men, utfordringer kan oppstår når krav endres ofte eller strukturen ikke følges ordentlig. Har opplevd dette selv da vi jobbet med Scrum og man ble litt for fokusert på koding at man glemte daily standups og diskusjoner, noe som gjorde at man mistet litt overblikket over utviklingen og hvordan andre lå an. Dette måtte vi da ta opp igjen senere, noe som jeg følte sakket ned prosessen noe. Man vil også få en sjeldnere push til produksjonsmiljøet i Scrum enn i DevOps, da man kun skal pushe til produksjon i slutten av hver sprint. I DevOps derimot, fokuserer man mer på den kontinuerlige integrasjonen og leveransen, med automatiserte prosesser. Dette gjør at man pusher ofte til produksjonsmiljøet og kan da oppdage feil tidligere. Personlig har dette vært en veldig givende måte å jobbe på, men også ganske frustrerende. Man føler og tror at alt fungerer helt fint på egen pc, så pusher man til AWS, og ingenting fungerer som det skal. Detter er derimot ikke veldig negativt, for det gjør at man raskt blir klar over feilen og har hjulpet meg til å oppdage ting mye tidligere som ville vært mye vanskeligere og fikse om jeg hadde fortsatt og bygd mye kode oppå det jeg gjorde feil. Scrum er en god metodikk det man vil ha en tydelig struktur og en nøye planlagt løype. Den kan passe bra når man skal utvikle et nytt produkt for en kunde og man ønsker kontinuerlig kommunikasjon med kunden mens man utvikler og endrer produktet. DevOps vil være foretrukket der man jobber rask og ønsker å hyppig rulle ut nye versjoner og oppdateringer, samt i et miljø hvor produktet allerede er «live», og man må fikse bugs og feil raskt.

### C. Det Andre Prinsippet - Feedback
Feedback er en kritisk del av DevOps, da dette gir utviklerne kunnskap om hvor i produktet det er mangler og eventuelt feil. Man kan da sette opp måleinstrumenter i for eksempel CloudWatch. Her kan man da se trender og endringer som kanskje gir rom for at man må forandre på koden eller hvordan man opererer. Man kan for eksempel se hvor mange salg en nettside gjør før og etter en endring, for å se om den nye layouten hjelper kundene eller potensielt gjør at de velger å ikke handle der. Dette kan man sette om med terraform som infrastruktur som kode, og da automatiseres for å holde tråd med DevOps prinsipper. Feedback vil også integreres i testfasen, da finner man raskt ut om visse funksjonaliteter fungerer eller har blitt ødelagt av nye endringer.
