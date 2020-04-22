## Text Classification Using Keras & TensorFlow on Amazon SageMaker

A modified version of this AWS SageMaker lab guide: https://github.com/aws-samples/amazon-sagemaker-keras-text-classification

* ### [Training and Hosting your Algorithm in Amazon SageMaker](./sagemaker_keras_text_classification.ipynb)
* ### Local Test:
  1. Open a terminal and run:
  ```shell
  cd container
  sh build_docker_local_test.sh
  ```
  2. Open another terminal
  ```shell
  cd container/local_test
  ./predict.sh input.json application/json
  ```
  
* ### [Endpoint Test](./endpoint_test.ipynb)
