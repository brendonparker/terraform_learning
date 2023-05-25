# Terraform Learning

### Summary

This is a repo I'm using as a learning playground for terraform. I plan to start simply, and slowly add over time. For a sample application, I'm using an API Gateway to proxy to a dotnet web api. There is a `/write` endpoint which writes to DynamoDB table and a `/read` endpoint to read to a table. I'm more focused on the infrastructure as code, less on what the application actually does.

### Objectives

- [x] Deploy simple API Gateway with DynamoDB table
- [ ] Explore refactor of terraform code to use modules and follow best practices for project setup
- [ ] Explore use of higher level components to reduce amount of terraform code
- [ ] Develop comparable AWS CDK deployment as to compare terraform with AWS CDK
- [ ] Investigate terraform CDK

## How to deploy

Build the application artifacts (requires [dotnet SDK](https://dotnet.microsoft.com/en-us/download))

```
rm -rf ./app/dist
dotnet publish ./app/MyApi -c Release -o ./app/dist
```

then
```
terraform apply -auto-approve
```