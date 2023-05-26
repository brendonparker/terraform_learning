# Terraform Learning

### Summary

This is a repo I'm using as a learning playground for terraform. I plan to start simply, and slowly add over time. For a sample application, I'm using an API Gateway to proxy to a dotnet web api. There is a `/write` endpoint which writes to DynamoDB table and a `/read` endpoint to read to a table. I'm more focused on the infrastructure as code, less on what the application actually does.

### Objectives

- [x] Deploy simple API Gateway with DynamoDB table
- [x] Refactor use modules (lambda, apigateway, dynamodb)
- [ ] Explore use of higher level components to reduce amount of terraform code
- [x] Develop comparable AWS CDK deployment as to compare terraform with AWS CDK
- [ ] Investigate terraform CDK
- [ ] Investigate remote backend for state

## How to deploy

### Initial one-time

```
terraform init
```

### For each deploy

Build the application artifacts (requires [dotnet SDK](https://dotnet.microsoft.com/en-us/download))

```
rm -rf ./app/dist
dotnet publish ./app/MyApi -c Release -o ./app/dist
```

then

```
terraform apply -auto-approve
```

## Benchmarks

These are not scientific. I ran each test once. However, I think they show that terraform will deploy more quickly than CDK/CloudFormation.

- [ ] Benchmark remote backend for state

| Action              | Environment | Backend | Duration (seconds)                                  |
| ------------------- | ----------- | ------- | --------------------------------------------------- |
| `terraform apply`   | New         | local   | ![40](https://progress-bar.dev/40?suffix=&scale=90) |
| `terraform apply`   | Existing    | local   | ![28](https://progress-bar.dev/28?suffix=&scale=90) |
| `terraform destroy` | Existing    | local   | ![27](https://progress-bar.dev/27?suffix=&scale=90) |
| `terraform apply`   | New         | remote  | ?                                                   |
| `terraform apply`   | Existing    | remote  | ?                                                   |
| `terraform destroy` | Existing    | remote  | ?                                                   |
| `cdk deploy`        | New         | _N/A_   | ![90](https://progress-bar.dev/90?suffix=&scale=90) |
| `cdk deploy`        | Existing    | _N/A_   | ![46](https://progress-bar.dev/46?suffix=&scale=90) |
| `cdk destroy`       | Existing    | _N/A_   | ![54](https://progress-bar.dev/54?suffix=&scale=90) |

_Note: Ideally the colors on the graphics above are inverted. from green -> red instead of red -> green_
