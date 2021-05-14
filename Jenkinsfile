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
      when { changeRequest target: "master" }
      steps {
        container("kustomize") {
          sh """
            export BRANCH=$($BRANCH_NAME | tr '[:upper:]' '[:lower:]')
            set +e
            kubectl create namespace $PROJECT-$BRANCH
            set -e
            cd kustomize/overlays/preview
            kustomize edit set namespace $PROJECT-$BRANCH
            kustomize edit set image $REGISTRY_USER/$PROJECT=$REGISTRY_USER/$PROJECT:$BRANCH-$BUILD_NUMBER
            cat ingress.yaml | sed -e "s@host: @host: ${BRANCH}@g" | tee ingress.yaml
            kustomize build . | kubectl apply --filename -
            kubectl --namespace $PROJECT-$BRANCH rollout status deployment jenkins-demo
            curl http://$BRANCH$PROJECT.3.124.47.165.nip.io
            kubectl delete namespace $PROJECT-$BRANCH
          """
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
}
