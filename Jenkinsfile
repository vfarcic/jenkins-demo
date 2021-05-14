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
      when { changeRequest() }
      steps {
        container("shipa") {
          sh """
            shipa app create $PROJECT-pr-$BRANCH_NAME
            shipa app deploy --app $PROJECT-pr-$BRANCH_NAME --image ${REGISTRY_USER}/${PROJECT}:$BRANCH_NAME-${BUILD_NUMBER}
            echo Running tests...
            shipa app remove --app $PROJECT-pr-$BRANCH_NAME
          """
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
}

