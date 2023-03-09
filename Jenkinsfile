pipeline {
    environment {
        IMAGEN = "evanticks/app-examen"
        LOGIN = 'USER_DOCKERHUB'
    }
    agent none
    stages {
        stage("Construccion") {
            agent any
            stages {
                stage('CloneAnfitrion') {
                    steps {
                        git branch:'main',url:'https://github.com/Evanticks/app-examen.git'
                    }
                }
                stage('BuildImage') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGEN:latest"
                        }
                    }
                }
                stage('UploadImage') {
                    steps {
                        script {
                            docker.withRegistry( '', LOGIN ) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('RemoveImage') {
                    steps {
                        sh "docker rmi $IMAGEN:latest"
                    }
                }
                stage ('SSH') {
                    steps{
                        sshagent(credentials : ['SSH_ROOT']) {
                            sh 'ssh -o StrictHostKeyChecking=no shinji@evangelion.entrebytes.org docker rmi -f $IMAGEN:latest'
                            sh 'ssh -o StrictHostKeyChecking=no shinji@evangelion.entrebytes.org wget https://raw.githubusercontent.com/Evanticks/docker-django/main/docker-compose.yaml -O docker-compose.yaml'
                            sh 'ssh -o StrictHostKeyChecking=no shinji@evangelion.entrebytes.org docker-compose up -d --force-recreate'
                        }
                    }
                }
            }
        }           
    }
    post {
        always {
            mail to: 'antonio@antonio.gonzalonazareno.org',
            subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
            body: "${env.BUILD_URL} has result ${currentBuild.result}"
        }
    }
}
