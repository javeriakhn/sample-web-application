currentBuild.displayName = "Final_Demo # "+currentBuild.number


def getDockerTag() {
    def tag = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
    return tag
}

pipeline {
    agent any
    environment {
        Docker_tag = getDockerTag()
    }

    stages {
        stage('Quality Gate Static Check') {
            agent {
                docker {
                    image 'maven'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                script {
                    withSonarQubeEnv('sonarserver') {
                        sh "mvn sonar:sonar"
                    }
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Build') {
            agent any
            steps {
                script {
                    sh 'cp -r ../devops-training@2/target .'
                    sh "docker build . -t deekshithsn/devops-training:${Docker_tag}"
                    withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
                        sh 'docker login -u deekshithsn -p $docker_password'
                        sh "docker push deekshithsn/devops-training:${Docker_tag}"
                    }
                }
            }
        }

        stage('Ansible Playbook') {
            agent any
            steps {
                script {
                    def final_tag = Docker_tag.replaceAll("\\s", "")
                    echo "${final_tag}test"
                    sh "sed -i \"s/docker_tag/$final_tag/g\" deployment.yaml"
                    ansiblePlaybook become: true, installation: 'ansible', inventory: 'hosts', playbook: 'ansible.yaml'
                }
            }
        }
    }
}
