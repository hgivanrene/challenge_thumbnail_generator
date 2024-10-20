# challenge_thumbnail_generator
This repository is for developing the coding challenge to create a thumbnail generator

# Objective:
The Thumbnail Generator project aims to automate the generation of thumbnails for images uploaded to an AWS S3 bucket. It uses AWS Lambda function triggered by S3 events to create thumbnails for images stored in the designated bucket.

# Features:
Automatically generates thumbnails for images uploaded to the source S3 bucket.
Use AWS Lambda function written in Python.
AWS CloudWatch monitoring and logs.

# Components:
AWS S3 Bucket: Stores original images and generated thumbnails.
AWS Lambda Function: Responsible for generating thumbnails upon image upload events.
AWS CloudWatch Logs: Logs events and errors for monitoring and troubleshooting.
Terraform Configuration: Infrastructure-as-Code (IaC) using Terraform to provision and manage AWS resources.

# Dependencies:
Terraform
AWS CLI
Python (for custom Lambda function)

# Repo clonning
git clone git@github.com:hgivanrene/challenge_thumbnail_generator.git # This command is when you have your ssh key configured in the repo. This option is quite safer.
git clone gh repo clone hgivanrene/challenge_thumbnail_generator # This option is to clone the repo using the web URL.

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

