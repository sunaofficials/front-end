pipeline {
  agent any

  environment {
    IMAGE_NAME = "sunaodisha/sockshop-frontend"
    REGISTRY_CREDENTIAL = "docker-gate"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
        cd front-end
        docker build -t $IMAGE_NAME:$BUILD_NUMBER .
        '''
      }
    }

    stage('Push Image') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', REGISTRY_CREDENTIAL) {
            sh "docker push $IMAGE_NAME:$BUILD_NUMBER"
          }
        }
      }
    }

    stage('Update GitOps Repo') {
      steps {
        sh '''
        rm -rf sockshop-gitops
        git clone https://github.com/sunaofficials/sockshop-gitops.git
        cd sockshop-gitops/frontend

        sed -i "s|image:.*|image: $IMAGE_NAME:$BUILD_NUMBER|g" deployment.yaml

        git config user.email "santanu.nayak@harman.com"
        git config user.name "Santanu"
        git add .
        git commit -m "Update frontend image to $BUILD_NUMBER"
        git push
        '''
      }
    }
  }
}
