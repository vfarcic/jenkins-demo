pipeline {
  agent {
    kubernetes {
      defaultContainer "shell"
      yamlFile "jenkins-pod.yaml"
    }
  }
  environment {
    PROJECT = "jenkins-demo"
  }
  stages {
    stage("Build") {
      steps {
        container("kaniko") {
          sh "/kaniko/executor --context `pwd` --destination vfarcic/jenkins-demo:latest --destination vfarcic/${PROJECT}:${BUILD_NUMBER}"
        }
      }
    }
    stage("Deploy PR") {
    //   when {
    //       expression { env.BRANCH_NAME != "master" }
    //   }
      steps {
        container("shipa") {
          sh "echo $BRANCH_NAME"
        //   sh "shipa app create $PROJECT-pr-$BRANCH_NAME"
        }
      }
    }
  }
}

