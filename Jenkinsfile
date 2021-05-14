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
          sh "/kaniko/executor --context `pwd` --destination vfarcic/jenkins-demo:latest --destination ${REGISTRY_USER}/${PROJECT}:$BRANCH_NAME-${BUILD_NUMBER}"
        }
      }
    }
    stage("Test") {
      when { not { branch "master" } }
      steps {
        container("shipa") {
          sh "shipa app create $PROJECT-$BRANCH_NAME-${BUILD_NUMBER}"
          sh "shipa app deploy --app $PROJECT-$BRANCH_NAME-${BUILD_NUMBER} --image ${REGISTRY_USER}/${PROJECT}:$BRANCH_NAME-${BUILD_NUMBER}"
          sh "echo Running tests..."
        }
      }
    }
    stage("Deploy") {
      when { branch "master" }
      steps {
        container("shipa") {
          sh "shipa app deploy --app $PROJECT --image ${REGISTRY_USER}/${PROJECT}:$BRANCH_NAME-${BUILD_NUMBER}"
        }
      }
    }
  }
  post {
    always {
      sh "shipa app remove --app $PROJECT-$BRANCH_NAME-${BUILD_NUMBER} --assume-yes"
    }
  }
}
