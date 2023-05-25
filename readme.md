## Build Source for Lambda
```
rm -rf ./app/dist
dotnet publish ./app/MyApi -c Release -o ./app/dist
```

## Deploy
```
terraform apply -auto-approve
```