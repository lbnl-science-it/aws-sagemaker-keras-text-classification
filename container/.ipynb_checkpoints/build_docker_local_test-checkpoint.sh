#!/bin/sh
####################################################
########## Download and unzip the dataset ##########
####################################################
cd ../data/
wget https://danilop.s3-eu-west-1.amazonaws.com/reInvent-Workshop-Data-Backup.zip && unzip reInvent-Workshop-Data-Backup.zip
mv reInvent-Workshop-Data-Backup/* ./
rm -rf reInvent-Workshop-Data-Backup reInvent-Workshop-Data-Backup.zip
cd ../container/

#################################################
######### Buildi the SageMaker Container ########
#################################################
algorithm_name=sagemaker-keras-text-classification

chmod +x sagemaker_keras_text_classification/train
chmod +x sagemaker_keras_text_classification/serve

account=$(aws sts get-caller-identity --query Account --output text)

# Get the region defined in the current configuration (default to us-west-2 if none defined)
region=$(aws configure get region)
region=${region:-us-west-2}

fullname="${account}.dkr.ecr.${region}.amazonaws.com/${algorithm_name}:latest"

# If the repository doesn't exist in ECR, create it.

aws ecr describe-repositories --repository-names "${algorithm_name}" > /dev/null 2>&1

if [ $? -ne 0 ]
then
    aws ecr create-repository --repository-name "${algorithm_name}" > /dev/null
fi

# Get the login command from ECR and execute it directly
#$(aws ecr get-login --region ${region} --no-include-email)
$(aws ecr get-login --no-include-email --region ${region} --registry-ids 763104351884)

# Build the docker image locally with the image name and then push it to ECR
# with the full name.

# On a SageMaker Notebook Instance, the docker daemon may need to be restarted in order
# to detect your network configuration correctly.  (This is a known issue.)
if [ -d "/home/ec2-user/SageMaker" ]; then
  sudo service docker restart
fi

docker build  -t ${algorithm_name} .
docker tag ${algorithm_name} ${fullname}

################################
########## Local Test ########## 
################################
cd ../data
cp -a . ../container/local_test/test_dir/input/data/training/
cd ../container
cd local_test
### Train
./train_local.sh ${fullname}
### Prediction
./serve_local.sh ${fullname}


