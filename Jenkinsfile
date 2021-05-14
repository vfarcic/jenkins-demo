pipeline {
  agent {
    kubernetes {
      defaultContainer "shell"
      yamlFile "jenkins-pod.yaml"
    }
  }
  stages {
    stage('Build') {
      steps {
        container('kaniko') {
          checkout scm
          sh "/kaniko/executor --context `pwd` --destination vfarcic/jenkins-demo:latest --destination vfarcic/jenkins-demo:${BUILD_NUMBER}"
        }
      }
    }
  }
}

