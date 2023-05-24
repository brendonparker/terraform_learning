## Build Source for Lambda
```
rm -rf dist
dotnet publish ./app/MyApi -c Release -o dist
```

## Deploy
```
terraform apply -auto-approve
```