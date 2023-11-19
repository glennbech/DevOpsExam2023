# ToDo List

Candidate Nr: 2011

## Oppgave 1. Kjell's Python kode
### A. SAM & GitHub actions workflow
For å kjøre [python-deploy.yml](.github/workflows/python-deploy.yml) må du legge in IAM key og IAM secret key fra AWS brukeren din på GitHub secrets
For å teste applikasjonen etter den kjører kan du bruke kommandoene under. Du kan bytte ut BUCKET_NAME med navnet på din egen bucket, men kan godt bruke min. Men du må bytte ut *** med dine egne keys
* docker run -p 8080:8080 -e AWS_ACCESS_KEY_ID=*** -e AWS_SECRET_ACCESS_KEY=*** -e BUCKET_NAME=simbucket2011 ppe
* docker run -e AWS_ACCESS_KEY_ID=***  -e AWS_SECRET_ACCESS_KEY=***  -e BUCKET_NAME=simbucket2011 kjellpy

### B. Docker container


## Oppgave 2. Overgang til Java og Spring boot
### A. Dockerfile


### B. GitHub Actions workflow for container image og ECR


## Oppgave 3. Terraform, AWS Apprunner og Infrastruktur som kode
### A. Kodeendringer og forbedringer


### B. Terraform i GitHub Actions
For å kjøre [java-deploy.yml](.github/workflows/java-deploy.yml) må du legge in IAM key og IAM secret key fra AWS brukeren din på GitHub secrets, med mindre du allerede gjorde det for Pythin scripted.
Du kan teste applikasjonen med å kjøre curl kommandoen under for å teste applikasjonen som kjører på mitt domene/apprunner
* curl -X GET "https://dx27uij3b5.eu-west-1.awsapprunner.com/scan-ppe?bucketName=simbucket2011"
Eller, du kan kjøre kommandoen under når du tester lokalt
* curl http://localhost:8080/scan-ppe?bucketName=simbucket2011

## Oppgave 4. Feedback
### A. Utvid applikasjonen og legg inn "Måleinstrumenter"

* [x] 1: Meter: Measure the amount of violations over time to trace a pattern of improvement or decline. 
* [x] 2: Timer: Measure the performance of the end points
* [ ] 3: Gauge: Count amount of people in building at any time
* [ ] 4: 
* [ ] 5: 

Det føltes naturlig å registrere hvor mange som brøt de forksjellige PPE reglene. Så jeg lagde en counter for hver type, og en som målte totale violations mellom alle.
Dette vil gi bedriften informasjon om hvor mange som bryter reglene om utstyr.
Koblet til dette, valgte jeg å måle en prosent av hvor mange av bildene hvor det var regelbrudd. 

Jeg valgte også å måle latancy på de forskjellige funksjonene, da kan man måle om det er tider av dagen hvor ting sinkes, og man kan se om man ønsker å gi applikasjonen mer resurser så den kjører mer effektivt.




### B. CloudWatch Alarm og Terraform moduler


## Oppgave 5. Drøfteoppgaver
### A. Kontinuerlig Integrering


### B. Sammenligning av Scrum/Smidig og DevOps fra et Utviklers Perspektiv


### C. Det Andre Prinsippet - Feedback


