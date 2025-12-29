pipeline {
  agent any

  environment {
    IMAGE_NAME = "sunaodisha/sockshop-frontend"
    TAG = "${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        git credentialsId: 'github-sant',
            url: 'https://github.com/sunaofficials/front-end.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          docker build -t $IMAGE_NAME:$TAG .
        '''
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'docker-sant',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
            docker push $IMAGE_NAME:$TAG
          '''
        }
      }
    }

    stage('Update GitOps Repo') {
      steps {
        git credentialsId: 'github-creds',
            url: 'https://github.com/sunaofficials/sockshop-gitops.git'

        sh '''
          sed -i "s|image:.*|image: $IMAGE_NAME:$TAG|" frontend/deployment.yaml
          git add frontend/deployment.yaml
          git commit -m "Update frontend image to $TAG"
          git push
        '''
      }
    }
  }
}
