pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - cat
    tty: true
  volumeMounts:
  - name: kaniko-secret
    mountPath: /kaniko/.docker/
volumes:
- name: kaniko-secret
  secret:
    secretName: regcred
    items:
    - key: .dockerconfigjson
      path: config.json
"""
    }
  }
  stages {
    stage('Build') {
      steps {
        container('kaniko') {
          checkout scm
          sh '/kaniko/executor --context `pwd` --destination vfarcic/jenkins-demo:0.0.1'
        }
      }
    }
  }
}
