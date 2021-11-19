# webapp-demo

Builds and deploys a basic REST API into Kubernetes.

## Table of Contents
1. [Usage](#usage)
1. [Building the app](#building-the-app)
1. [Deploying the app](#deploying-the-app)

## Usage
This API exposes the following endpoints:

| Path | Method | Response Code | Response |
|------|--------|---------------|----------|
| `/` | `GET` | 200 | "This is a landing page with no content." |
| `/v1/liveness` | `GET` | 200 | "IAMOK" |
| `/v1/hello` | `GET` | 200 | "Greetings and salutations." |
| `/v1/hello/{name}` | `POST` | 201 | "And hello to you, {name}" |
| `/v1/number` | `GET` | 200 | JSON object of statistics and their modifiers |

## Building the app
Builds are automated via Jenkins.

**Build Job:** <http://jenkins.kokolis.net/job/webapp-demo/job/Build-webapp/>

Images are pushed into the container registry on the `develop` branch and release tags.

## Deploying the app
Terraform is used to define the Kubernetes service.  It is deployed when a tagged release is built.

**Deploy Job:** <http://jenkins.kokolis.net/job/webapp-demo/job/Deploy-webapp/>
