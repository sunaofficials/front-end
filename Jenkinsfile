pipeline {
  agent any

  environment {
    IMAGE_NAME = "sunaodisha/sockshop-frontend"
    TAG = "${BUILD_NUMBER}"
  }

  stages {

    /* =========================
       CI : Checkout Frontend
       ========================= */
    stage('Checkout Frontend') {
      steps {
        git credentialsId: 'github-sant',
            url: 'https://github.com/sunaofficials/front-end.git',
            branch: 'master'
      }
    }

    /* =========================
       CI : Build Docker Image
       ========================= */
    stage('Build Docker Image') {
      steps {
        sh """
          docker build -t ${IMAGE_NAME}:${TAG} .
        """
      }
    }

    /* =========================
       CI : Push Docker Image
       ========================= */
    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'github-sant',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh """
            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
            docker push ${IMAGE_NAME}:${TAG}
          """
        }
      }
    }

    /* =========================
       CD : Update GitOps Repo
       ========================= */
    stage('Update GitOps Repo') {
      steps {
        dir('gitops') {

          /* Checkout GitOps repo */
          git credentialsId: 'github-sant',
              url: 'https://github.com/sunaofficials/sockshop-gitops.git',
              branch: 'main'

          /* Update deployment.yaml */
          sh """
            git config user.email "ssn@architect.com"
            git config user.name "sunaofficials"

            sed -i 's|image: .*|image: ${IMAGE_NAME}:${TAG}|' frontend/deployment.yaml

            git add frontend/deployment.yaml
            git commit -m "Update frontend image to ${TAG}"
          """

          /* Push using PAT explicitly */
          withCredentials([usernamePassword(
            credentialsId: 'github-sant',
            usernameVariable: 'GIT_USER',
            passwordVariable: 'GIT_TOKEN'
          )]) {
            sh """
              git push https://\$GIT_USER:\$GIT_TOKEN@github.com/sunaofficials/sockshop-gitops.git main
            """
          }
        }
      }
    }
  }
}
