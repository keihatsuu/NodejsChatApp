pipeline {
    agent any
    environment
    {
        //Change here
        DOCKERHUB_CREDENTIALS ='cybr-3120'
        IMAGE_NAME ='keihatsu/nodejschatapp'
    }
    
    stages
    {
        stage('Cloning Git')
        {
            steps
            {
                checkout scm
            }
        }
        stage('BUILD-AND-TAG')
        {
            agent { 
                label 'hello-world-soto'
            }
            steps {
                script
                {
                    echo "Building Docker image ${IMAGE_NAME}..."
                    app = docker.build("${IMAGE_NAME}")
                    app.tag("latest")
                }
            }
        }
        stage('SonarQube Analysis') {
            agent {
                label 'hello-world-soto'
            }
            steps {
                script {
                    def scannerHome = tool 'SonarQube-Scanner'
                    withSonarQubeEnv('SonarQube-Installations') {
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=gameapp \
                            -Dsonar.sources=."
                    }
                }
            }
        }
        stage('POST-TO-DOCKERHUB')
        {
            agent { label 'hello-world-soto' }
            steps {
                script {
                    echo "Pushing image ${IMAGE_NAME}:latest to Docker Hub..."
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKERHUB_CREDENTIALS}") {
                        app.push("latest")
                    }
                }
            }
        }
        //REMOVE IF NO WORK CUZ NO SNYK
        stage('DAST')
        {
            steps
            {
                sh 'echo Running DAST scan...'
            }
        }
        stage('DEPLOYMENT')
        {
            agent { label 'hello-world-soto' }
            steps
            {
                echo 'Starting deployment using docker-compose...'
                script
                {
                    dir("${WORKSPACE}")
                    {
                        sh '''
                            docker-compose down
                            docker-compose up -d
                            docker ps
                        '''
                    }
                }
                echo 'Deployment completed succcessfully'
            }
        }
    }
}
