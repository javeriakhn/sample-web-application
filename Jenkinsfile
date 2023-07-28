currentBuild.displayName = "Final_Demo # "+currentBuild.number

   def getDockerTag(){
        def tag = sh script: 'git rev-parse HEAD', returnStdout: true
        return tag

		 

	pipeline {
    agent any
    environment {
        Docker_tag = getDockerTag()
    }
    stages {
        stage ('build'){
            steps {
                script {
                    sh "mvn clean install"
                }
            }
        }

        stage('build docker image and push') {
            steps {
                script {
                    sh 'cp -r ../devops-training@2/target .'
                    sh 'docker build . -t javeriakashan/devops-training:$Docker_tag'
                    withCredentials([string(credentialsId: 'docker_password', variable: 'DOCKER_PASSWORD')]) {
                        sh 'docker login -u javeriakashan -p $DOCKER_PASSWORD'
                        sh 'docker push javeriakashan/devops-training:$Docker_tag'
                    }
                }
            }
        }

        stage('ansible playbook') {
            steps {
                script {
                    sh '''
                        final_tag=$(echo $Docker_tag | tr -d ' ')
                        echo ${final_tag}test
                        sed -i "s/docker_tag/$final_tag/g" deployment.yaml
                    '''
                        ansiblePlaybook installation: 'ansible', inventory: 'host', playbook: 'ansible.yaml', sudo: true
                }
            }
        }
    }
}
   }
		
               
	       
	       
	       
	      
    

	       
	       
	       
	      
    

