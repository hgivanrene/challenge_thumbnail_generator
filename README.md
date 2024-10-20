# challenge_thumbnail_generator
This repository is for developing the coding challenge to create a thumbnail generator

# Thumbnail generator architecture
We upload an image to a source S3 Bucket (input-image-bucket-hg01). Once this image is uploaded the event will send a notification to activate the lambda function that will have an IAM role assigned to access to the S3 buckets (Source and Target). The lambda function is going to make the transformation from the input image and is going to save the thumbnail image in the target S3 Bucket (thumbnail-image-bucket-hg01). All of this architecture, resources and permissions have been created and deployed with Terraform.

![Image of the architecture](Thumbnail_generator_architecture.jpg)

# Objective:
The Thumbnail Generator project aims to automate the generation of thumbnails for images uploaded to an AWS S3 bucket. It uses AWS Lambda function triggered by S3 events to create thumbnails for images stored in the designated bucket.

# Features:
Automatically generates thumbnails for images uploaded to the source S3 bucket.
Use AWS Lambda function written in Python.
AWS CloudWatch monitoring and logs.

# Components:
1. AWS S3 Bucket: Stores original images and generated thumbnails.
2. AWS Lambda Function: Responsible for generating thumbnails upon image upload events.
3. AWS CloudWatch Logs: Logs events and errors for monitoring and troubleshooting.
4. Terraform Configuration: Infrastructure-as-Code (IaC) using Terraform to provision and manage AWS resources.

# Dependencies:
1. Terraform
2. AWS CLI
3. Python (for custom Lambda function)

# Repo clonning
* git clone git@github.com:hgivanrene/challenge_thumbnail_generator.git # This command is when you have your ssh key configured in the repo. This option is quite safer.
* git clone gh repo clone hgivanrene/challenge_thumbnail_generator # This option is to clone the repo using the web URL.

# Install Terraform for MAC
    - Install Terraform with Homebrew (brew install terraform)
    - Verified installation (terraform -v)
    - Keep Terraform updated (brew upgrade terraform)

# Install AWS CLI for MAC
    - Install AWS CLI with Homebrew (brew install awscli)
    - Verified installation (aws --version)
    - Set up your AWS CLI (aws configure). It will ask you the next information:
        AWS Access Key ID: youy access key from AWS.
        AWS Secret Access Key: Your secret key from AWS.
    - Keep AWS CLI updated (brew upgrade awscli)

# Usage:
Deploy the infrastructure using Terraform.

    Init your work directory
    - terraform init

    Fix formart on your file
    - terraform fmt

    Validate terraform configuration
    - terraform validate

    Review your changes
    - terrafomr plan

    Accept and apply your changes
    - terrafomr apply

Upload your image to the input S3 bucket to trigger thumbnail generation with lambda.

Monitor CloudWatch logs for processing details and errors.

