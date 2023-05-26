# Welcome to the CDK TypeScript project

Prior to running, you'll want to install the cdk globally:

```
npm install -g aws-cdk@2.73.0
```

I prefer to use profiles and environment variables to control my aws account/region, so for example:
```
set AWS_PROFILE=default
set AWS_REGION=us-east-1
```

If this is your first time using the CDK in the target account/region, you'll first need to boostrap the account/region:
```
cdk bootstrap
```

The `cdk.json` file tells the CDK Toolkit how to execute your app.

## Useful commands

* `yarn build`      compile typescript to js
* `yarn watch`      watch for changes and compile
* `cdk deploy`      deploy this stack to your default AWS account/region
* `cdk diff`        compare deployed stack with current state
* `cdk synth`       emits the synthesized CloudFormation template
