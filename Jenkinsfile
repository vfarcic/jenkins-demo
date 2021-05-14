pipeline {
  agent {
    kubernetes {
      defaultContainer "shell"
      yamlFile "jenkins-pod.yaml"
    }
  }
  stages {
    stage("Build") {
      steps {
        container("kaniko") {
          sh "/kaniko/executor --context `pwd` --destination vfarcic/jenkins-demo:latest --destination vfarcic/jenkins-demo:${BUILD_NUMBER}"
        }
      }
    }
    stage("Deploy") {
      steps {
        container("shipa") {
          sh "whoami"
          sh "ls -l /root/.shipa"
          sh "shipa target add shipa-cloud target.shipa.cloud --set-current"
          sh "shipa login"
        }
      }
    }
  }
}
