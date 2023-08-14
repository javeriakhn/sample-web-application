def Docker_tag = getDockerTag()

pipeline {
    agent any

    stages {
        stage('Quality Gate Static Check') {
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

        stage('Build and Push Docker Image') {
            steps {
                script {
                    sh 'cp -r ../devops-training@2/target .'
                    sh "docker build . -t javeriakashan/devops-training:${Docker_tag}"
                    withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
                        sh 'docker login -u javeriakashan -p $docker_password'
                        sh "docker push javeriakashan/devops-training:${Docker_tag}"
                    }
                }
            }
        }

        stage('Ansible Playbook') {
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
