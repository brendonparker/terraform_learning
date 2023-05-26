import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import * as apigw from "aws-cdk-lib/aws-apigateway";
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as dynamodb from "aws-cdk-lib/aws-dynamodb";

export class MainStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const api = new apigw.RestApi(this, "RestApi", {
    });

    const table = new dynamodb.Table(this, "Table", {
      tableName: 'ApiTable',
      partitionKey: {
        name: 'PK',
        type: dynamodb.AttributeType.STRING
      },
    });

    const lambdaProxy = new lambda.Function(this, "Lambda", {
      memorySize: 1536,
      runtime: lambda.Runtime.DOTNET_6,
      handler: "MyApi",
      code: lambda.Code.fromAsset("../app/dist/"),
    });

    table.grantReadWriteData(lambdaProxy);

    api.root.addProxy({
      anyMethod: true,
      defaultIntegration: new apigw.LambdaIntegration(lambdaProxy),
    });
  }
}
