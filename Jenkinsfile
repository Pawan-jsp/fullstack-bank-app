pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }
    
    stages {
                stage('git pull') {
            steps {
                git branch: 'main', url: 'https://github.com/Pawan-jsp/fullstack-bank-app.git'
            }
        }
        stage('Owasp scan') {
            steps {
                dependencyCheck additionalArguments: '--scan	', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('trivy fs') {
            steps {
                sh 'trivy fs .'
            }
        }
        stage('sonarqube') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=full-stack-bank \
                    -Dsonar.projectKey=full-stack-bank '''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }
        stage('install nodeJS dependancies') {
            steps {
                sh 'npm install'
            }
        }
        stage('install nodeJS backend dependancies') {
            steps {
                dir('/var/lib/jenkins/workspace/full-stack-bank/app/backend/') {
                    sh 'npm install'
                }
            }
        }
        stage('install frontend dependancies') {
            steps {
                dir('/var/lib/jenkins/workspace/full-stack-bank/app/frontend/') {
                    sh 'npm install'
                }
            }
        }
        stage('docker container deploy') {
            steps {
                sh 'npm run compose:up -d' 
            }
        }
        stage('run command to tag local images') {
            steps {
                sh 'docker tag app_frontend baggipawan/full-stack-bank:frontend'
                sh 'docker tag app_backend baggipawan/full-stack-bank:backend'
                sh 'docker tag postgres:15.1 baggipawan/full-stack-bank:database'
            }
        }
        stage('push docker images') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {

                        sh 'docker login'
                        sh 'docker push baggipawan/full-stack-bank:backend'
                        sh ' docker push baggipawan/full-stack-bank:frontend'
                        sh ' docker push baggipawan/full-stack-bank:database'
                    }
                }
            }
        }
    }
}
