# Terraform Learning

### Summary

This is a repo I'm using as a learning playground for terraform. I plan to start simply, and slowly add over time. For a sample application, I'm using an API Gateway to proxy to a dotnet web api. There is a `/write` endpoint which writes to DynamoDB table and a `/read` endpoint to read to a table. I'm more focused on the infrastructure as code, less on what the application actually does.

### Objectives

- [x] Deploy simple API Gateway with DynamoDB table
- [x] Refactor use modules (lambda, apigateway, dynamodb)
- [ ] Explore use of higher level components to reduce amount of terraform code
- [x] Develop comparable AWS CDK deployment as to compare terraform with AWS CDK
- [ ] Investigate terraform CDK
- [x] Investigate remote backend for state

## How to deploy

### Initial/One-Time

```
terraform init
```

### For Each Deploy

Build the application artifacts (requires [dotnet SDK](https://dotnet.microsoft.com/en-us/download))

```
rm -rf ./app/dist
dotnet publish ./app/MyApi -c Release -o ./app/dist
```

then

```
terraform apply -auto-approve
```

## AWS CDK

Part of this learning is to compare the terraform effort/experience to what I am already familiar with using the AWS CDK. To that end, I setup the same infrastructure as code using the AWS CDK [here](aws_cdk)

## Benchmarks

These are not scientific. I ran each test once. However, I think they show that terraform will deploy more quickly than CDK/CloudFormation.

Using a remote backend (s3) for the terraform state did not seem to have any noticable change to the deploy process.

| Action              | Environment | Duration (seconds)                                  |
| ------------------- | ----------- | --------------------------------------------------- |
| `terraform apply`   | New         | ![40](https://progress-bar.dev/40?suffix=&scale=90) |
| `terraform apply`   | Existing    | ![28](https://progress-bar.dev/28?suffix=&scale=90) |
| `terraform destroy` | Existing    | ![27](https://progress-bar.dev/27?suffix=&scale=90) |
| `cdk deploy`        | New         | ![90](https://progress-bar.dev/90?suffix=&scale=90) |
| `cdk deploy`        | Existing    | ![46](https://progress-bar.dev/46?suffix=&scale=90) |
| `cdk destroy`       | Existing    | ![54](https://progress-bar.dev/54?suffix=&scale=90) |

_Note: Ideally the colors on the graphics above are inverted. from green -> red instead of red -> green_
