# Cloud Resume Challenge
Like many others, I decided to start gaining experience in the cloud by trying out the [cloud resume challenge](https://cloudresumechallenge.dev/) by Forrest Brazeal. With this challenge, you use many different cloud technologies and products to host a website, showcasing your resume. 

With this challenge, I chose to use AWS as my cloud provider. Some of the services used include AWS S3 for storage, AWS Lambda for serverless functions, AWS API Gateway for managing APIs, and AWS DynamoDB for database storage. One of the highlights of this challenge to me was to provision the infrastructure using IaC. The challenge suggested using SAM, however I chose Terraform as my language of choice.

>Click [here](https://www.kendrickkim.com) if you would like to see the finished product!

## Technologies, Services, Tools, and Frameworks
As mentioned above, I used AWS as my cloud provider. Within AWS, I used the following services:

API Gateway, CloudFront, CodeBuild, CodePipeline, DynamoDB, Identity and Access Management, Key Management Service, Lambda, Route53, and S3.

Other technologies I utilized for this project include Terraform for infrastructure provisioning, HTML for the website, JavaScript for communicating with the API, and Python used in Lambda. I have also used two Python libraries: Boto3 and simplejson.

## How it works
Amazon S3 is the perfect service for simple website hosting because of its convenient and cost-effective nature. The bucket contains all frontend files, which is then configured for static website hosting. I did not want anyone accessing the bucket directly, which is why the bucket blocks public access. CloudFront is the only service that is allowed to perform any action on the S3 bucket. 

When an end user navigates to the website, Route53 provides DNS translation, at which point the website loads onto the end user's browser. As the content is loaded, a JavaScript function will be loaded in and will make a call to API Gateway, which triggers a Lambda function written in Python to update and return the page visitor count value stored in DynamooDB.

## Deployment
The original challenge written for AWS describes using GitHub actions and SAM to deploy to AWS. However I decided to gain as much experience using AWS's services, so I chose to go with CodePipeline.

I debated between using CodeCommit or GitHub for version control, but I ended using GitHub as I feel it is more widely used. Because of this, instead of using CodeCommit as the pipeline's source, AWS's CodePipeline uses a CodeStar Connection to connect to the GitHub repository which has a webhook to trigger the pipeline whenever a commit is pushed to GitHub. Once a commit is pushed to GitHub, the Pipeline will trigger and run through its stages.

After the source stages runs, the validate stage will run to validate the Terraform code. If the check passes, the plan stage will run. Once the plan stage checks pass, the infrastructure will then be deployed.

