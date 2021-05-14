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
        container("kustomize") {
          sh """
            set +e
            kubectl create namespace $PROJECT-$BRANCH_NAME
            set -e
            cd kustomize/overlays/preview
            kustomize edit set namespace $PROJECT-$BRANCH_NAME
            kustomize edit set image $REGISTRY_USER/$PROJECT=$REGISTRY_USER/$PROJECT:$BRANCH_NAME-$BUILD_NUMBER
            cat ingress.yaml
            echo 111
            cat ingress.yaml | sed -e "s@host: @host: xyz@g" | tee ingress.yaml
            echo 222
            cat ingress.yaml
            echo 333
            kustomize build . | kubectl apply --filename -
            kubectl --namespace $PROJECT-$BRANCH_NAME rollout status deployment jenkins-demo
          """
          sh "curl https://google.com"
        //   TODO: Delete the namespace
        }
      }
    }
    stage("Deploy") {
      when { branch "master" }
      steps {
        container("kustomize") {
          sh """
            cd kustomize/overlays/production
            kustomize edit set image ${REGISTRY_USER}/${PROJECT}=${REGISTRY_USER}/${PROJECT}:$BRANCH_NAME-${BUILD_NUMBER}
            kustomize build . | kubectl apply --filename -
          """
        }
      }
    }
  }
  post {
    failure {
      container("shipa") {
        sh "shipa app remove --app $PROJECT-$BRANCH_NAME-${BUILD_NUMBER} --assume-yes"
      }
    }
  }
}
