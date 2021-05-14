pipeline {
  agent {
    kubernetes {
      defaultContainer "shell"
      yamlFile "jenkins-pod.yaml"
    }
  }
  environment {
    PROJECT = "jenkins-demo"
    REGISTRY_USER = "vfarcic"
  }
  stages {
    stage("Build") {
      steps {
        container("kaniko") {
          sh "/kaniko/executor --context `pwd` --destination vfarcic/jenkins-demo:latest --destination ${REGISTRY_USER}/${PROJECT}:${BUILD_NUMBER}"
        }
      }
    }
    stage("Deploy PR") {
      when { changeRequest target: 'master' }
      steps {
        container("shipa") {
          sh "shipa app create $PROJECT-pr-$BRANCH_NAME"
          // TODO: Continue
        }
      }
    }
    stage("Deploy Prod") {
      when { branch "master" }
      steps {
        container("shipa") {
          sh "ls -l /root/.shipa/"
          sh "ls -l /root/.shipa/certificates"
          sh "ls -l /root/.shipa/certificates/jenkins"
          sh "ls -l /root/.shipa/certificates/jenkins/ca.crt"
          sh "shipa app create $PROJECT"
          sh "shipa app deploy --app $PROJECT --image ${REGISTRY_USER}/${PROJECT}:${BUILD_NUMBER}"
        }
      }
    }
    stage("Test") {
      when { changeRequest target: 'master' }
      steps {
        echo "Running tests..."
      }
    }
  }
}
