# Minimum example of terraform - CodeDeploy + Lambda.
## Deployment process
First, terraform provisions all resources.

![Step1](./doc/deploy_process_step1.drawio.svg)

When provisioning is completed and Lambda is updated, terraform triggers CodeDeploy to update Lambda version tied to specific alias.

![Step2](./doc/deploy_process_step2.drawio.svg)

In this step, you can choose deployment method below.

- Blue/Green
- Canary
- All at once

## Code structure
```
terraform
├── envs
│   └── example
│       ├── aws.tf
│       └── main.tf
└── module
    ├── codedeploy
    │   ├── codedeploy.tf
    │   ├── iam.tf
    │   ├── temp.yml
    │   └── variables.tf
    └── lambda
        ├── iam.tf
        ├── lambda.tf
        ├── output.tf
        ├── src
        │   └── main.py
        ├── upload
        │   └── lambda.zip
        └── variables.tf
```
