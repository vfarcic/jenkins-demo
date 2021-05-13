pipeline {
  agent {
    kubernetes {
      yaml """\
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
            - name: regcred
              mountPath: /secret
            env:
            - name: GOOGLE_APPLICATION_CREDENTIALS
              value: /secret/regcred.json
        volumes:
        - name: regcred
          secret:
            secretName: regcred
        """.stripIndent()
    }
  }
  stages {
    stage('Build') {
      steps {
        container('kaniko') {
          checkout scm
          sh '/kaniko/executor -c `pwd` --cache=true --destination=gcr.io/myprojectid/myimage'
        }
      }
    }
  }
}
