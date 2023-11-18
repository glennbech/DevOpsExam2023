# ToDo List

Candidate Nr: 2011

## Oppgave 1. Kjell's Python kode
### A. SAM & GitHub actions workflow 
* [x] Setup project in C9
  * [x] Setup GitHub timeout and connection
  * git config --global credential.helper "cache --timeout=86400"
  * git config --global user.name "github brukernavn"
  * git config --global user.email "email for github bruker"
  * [x] Install MVN
  * [x] GitHub secrets (IAM)
* [x] Test Kjell's scripts (successfully get images from kjellsimagebucket)
* [x] Fix Kjell script
  * [x] Remove hardcoded bucket name, use environment
  * [x] Test API with images
* [x] GitHub Actions flow for SAM apps. 
  * [x] Every push to main should build and deploy the lambda function
  * [x] Push to other branches should just build
* [ ] Explain what the sensor must do to make the workflow run using their own GitHub account.

### B. Docker container
* [x] Make a dockerfile that builds and runs the code. 

## Oppgave 2. Overgang til Java og Spring boot
### A. Dockerfile
* [x] Add dockerfile for java

### B. GitHub Actions workflow for container image og ECR
* [x] Add workflow for java with ECR push, + hash and latest tag

## Oppgave 3. Terraform, AWS Apprunner og Infrastruktur som kode
### A. Kodeendringer og forbedringer
* [x] Remove hard coded values for service
* [x] Reduce CPU to 256 and memory to 1024

### B. Terraform i GitHub Actions
* [x] Make GitHub action also run the terraform code
* [x] Have Terraform run after pushes to main that build Docker container images
* [x] Add terraform provider, use S3 bucket that we have used during practice
* [ ] Explain what the sensor must do to make the workflow run using their own GitHub account.

## Oppgave 4. Feedback

### A. Utvid applikasjonen og legg inn "Måleinstrumenter"
* [x] Add more endpoints
* [x] Change the java app to allow Micrometer framework
* [x] Configure the micrometer to work with CloudWatch
* [ ] Implement various meters
* [ ] Write a short explanation for why I chose those meters

### B. CloudWatch Alarm og Terraform moduler
* [ ] Add a CloudWatch alam through Terraform that sends an email alert when triggered.
* [ ] We chose the criteria for the alarm, but must explain why.
* [ ] Make it its own Terraform module, make sure not too many variables must be set

## Oppgave 5. Drøfteoppgaver

### A. Kontinuerlig Integrering
* [ ] Explain what "Kontinuelig Integrering" is

### B. Sammenligning av Scrum/Smidig og DevOps fra et Utviklers Perspektiv
* [ ] Compare Scrum/Agile and DevOps from a Developers perspective

### C. Det Andre Prinsippet - Feedback
* [ ] Discuss how feedback help continual improvement and how to implement it

