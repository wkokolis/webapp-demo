pipeline {
  agent any 

  environment {
    def scmVars = checkout scm

    // basic variables
    NAMESPACE			= 'wkokolis'
    MAILTO			= 'william@kokolis.net'
    DEPLOYJOB			= 'webapp-demo/Deploy-webapp'

    // what are we making, and what is it based on?
    IMAGE       		= 'cicd-demo'
    TAG				= "${env.TAG_NAME ? "${env.TAG_NAME}" : "${env.GIT_COMMIT}"}"
    BASE_NAMESPACE		= 'library'
    BASE        		= 'python'
    BASEVER			= '3.9-alpine'
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 30, unit: 'MINUTES')
    disableConcurrentBuilds()
    datadog(tags: ["job_type:build","service:cicddemo"])
  }

  stages {
    stage('Pull latest base image') {
      steps {
        pullBaseImage(
          namespace: "${env.BASE_NAMESPACE}",
          image: "${env.BASE}",
          tag: "${env.BASEVER}"
        )
      }
    }
    stage('Execute unit tests') {
      when {
        anyOf {
          branch "master"
          branch "develop"
        }
      }
      agent {
        docker {
          image "${env.BASE}:${env.BASEVER}"
          args '-v /opt/jenkins/workspace:/var/jenkins-home/workspace'
          reuseNode true
        }
      }
      steps {
        unitTestPython(
          method: 'pytest',
          location: 'tests/unit'
        )
      }
      post {
        failure {
          emailext (
            subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            body: """<p>FAILURE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]:<p>
              <p>Unit tests failed for ${env.JOB_NAME}.<br>
                 Please check the job logs at <a href="${env.BUILD_URL}">${env.BUILD_URL}</a>.""",
            to: "${env.MAILTO}"
          )
        }
      }
    }
    stage('Build image') {
      steps {
        buildPushImage(
          namespace: "${env.NAMESPACE}",
          image: "${env.IMAGE}",
          tag: "${env.TAG}",
          push: "false"
        )
      }
      post {
        failure {
          emailext (
            subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            body: """<p>FAILURE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]:<p>
              <p>Container image build failed for ${env.JOB_NAME}.<br>  
                 Please check the job logs at <a href="${env.BUILD_URL}">${env.BUILD_URL}</a>.""",
            to: "${env.MAILTO}"
          )
        }
      }
    }
    stage('Security scan branches') {
      when {
        anyOf {
          branch "develop"
          branch "master"
        }
      }
      agent {
        docker {
          image "wkokolis/trivy:0.9.2"
          args '-v /opt/jenkins/workspace:/var/jenkins-home/workspace -v /usr/bin/docker:/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock'
          reuseNode true
        }
      }
      steps {
        catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
          trivyScan(
            namespace: "${env.NAMESPACE}",
            image: "${env.IMAGE}",
            tag: "${env.TAG}",
            mode: "permissive"
          )
        }
      }
      post {
        failure {
          emailext (
            subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            body: """<p>FAILURE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]:<p>
              <p>Image vulnerability scan failed for ${env.JOB_NAME}.<br>  
                 Please check the job logs at <a href="${env.BUILD_URL}">${env.BUILD_URL}</a>.""",
            to: "${env.MAILTO}"
          )
        }
      }
    }
    stage('Best-Practices scan') {
      when {
        anyOf {
          branch "develop"
          branch "master"
        }
      }
      steps {
        catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
          integrityScan(
            namespace: "${env.NAMESPACE}",
            image: "${env.IMAGE}",
            tag: "${env.TAG}",
            mode: "strict"
          )
        }
      }
      post {
        failure {
          emailext (
            subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            body: """<p>FAILURE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]:<p>
              <p>Image best-practices integrity scan failed for ${env.JOB_NAME}.<br>  
                 Please check the job logs at <a href="${env.BUILD_URL}">${env.BUILD_URL}</a>.""",
            to: "${env.MAILTO}"
          )
        }
      }
    }
    stage('Push image to registry') {
      when { 
        anyOf {
          branch "develop"
          buildingTag()
        }
      }
      steps {
        pushImage(
          namespace: "${env.NAMESPACE}",
          image: "${env.IMAGE}",
          tag: "${env.TAG}"
        )
      }
      post {
        failure {
          emailext (
            subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            body: """<p>FAILURE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]:<p>
              <p>Image failed to push to the registry for ${env.JOB_NAME}.<br>  
                 Please check the job logs at <a href="${env.BUILD_URL}">${env.BUILD_URL}</a>.""",
            to: "${env.MAILTO}"
          )
        }
      }
    }
    stage('Deploy to demo') {
      when { buildingTag() }
      steps {
        catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
          build job: "${env.DEPLOYJOB}", propagate: false, parameters: [
            [$class: 'StringParameterValue', name: 'ENVIR', value: "demo"],
            [$class: 'StringParameterValue', name: 'TAG', value: "${env.TAG}"]
          ]
        }
      }
    }
  }

  post {
    unstable {
      emailext (
        subject: "UNSTABLE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """<p>UNSTABLE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]:<p>
          <p>Something went wrong during the build process failed for ${env.JOB_NAME}.<br>  
             The build completed, but one or more security scans failed.</p>
          <p>Please check the job logs at <a href="${env.BUILD_URL}">${env.BUILD_URL}</a>.""",
        to: "${env.MAILTO}"
      )
    }
    failure {
      emailext (
        subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """<p>FAILURE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]:<p>
          <p>The overall build process failed for ${env.JOB_NAME}.<br>  
             Please check the job logs at <a href="${env.BUILD_URL}">${env.BUILD_URL}</a>.""",
        to: "${env.MAILTO}"
      )
    }
    cleanup {
      sh "docker rmi ${env.NAMESPACE}/${env.IMAGE}:${env.TAG} || exit 0"
      cleanWs()
      wsCleaner()
    }
  }
}
