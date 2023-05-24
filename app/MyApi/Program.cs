using Amazon.DynamoDBv2;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddAWSLambdaHosting(LambdaEventSource.RestApi);
builder.Services.AddDefaultAWSOptions(builder.Configuration.GetAWSOptions());
builder.Services.AddAWSService<IAmazonDynamoDB>();

builder.Services.AddSingleton<IDatabaseService, DatabaseService>();

var app = builder.Build();

// Eager load to help cold-start
app.Services.GetRequiredService<IDatabaseService>();

// Configure the HTTP request pipeline.
app.UseHttpsRedirection();

app.MapGet("/write", async ([FromServices] IDatabaseService db) =>
{
    await db.WriteAsync();
    return new { status = "Healthy!" };
});

app.MapGet("/read", async ([FromServices] IDatabaseService db) =>
{
    return await db.ReadAsync();
});

app.Run();
