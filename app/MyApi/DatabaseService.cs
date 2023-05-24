using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DocumentModel;

public interface IDatabaseService
{
    Task WriteAsync();
    Task<List<string>> ReadAsync();
}

public class DatabaseService : IDatabaseService
{
    private readonly Table _table;

    public DatabaseService(IAmazonDynamoDB dynamoDB)
    {
        _table = Amazon.DynamoDBv2.DocumentModel.Table.LoadTable(dynamoDB, "ApiTable");
    }

    public async Task WriteAsync()
    {
        var doc = new Document();
        doc["PK"] = DateTime.UtcNow.ToString("o");
        await _table.PutItemAsync(doc);
    }

    public async Task<List<string>> ReadAsync()
    {
        var search = _table.Scan(new ScanOperationConfig());
        var docs = await search.GetNextSetAsync();
        return docs.Select(x => x["PK"].AsString()).ToList();
    }
}