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
Kontinuerlig integrasjon er et software prinsipp 

### B. Sammenligning av Scrum/Smidig og DevOps fra et Utviklers Perspektiv


### C. Det Andre Prinsippet - Feedback


