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
          sh '/kaniko/executor -c `pwd` --cache=true --destination=gcr.io/myprojectid/myimage'
        }
      }
    }
  }
}

// pipeline {
//   agent {
//     kubernetes {
//       yaml """\
//         apiVersion: v1
//         kind: Pod
//         metadata:
//           labels:
//             some-label: some-label-value
//         spec:
//           containers:
//           - name: maven
//             image: maven:alpine
//             command:
//             - cat
//             tty: true
//           - name: busybox
//             image: busybox
//             command:
//             - cat
//             tty: true
//         """.stripIndent()
//     }
//   }
//   stages {
//     stage('Run maven') {
//       steps {
//         container('maven') {
//           sh 'mvn -version'
//         }
//         container('busybox') {
//           sh '/bin/busybox'
//         }
//       }
//     }
//   }
// }
