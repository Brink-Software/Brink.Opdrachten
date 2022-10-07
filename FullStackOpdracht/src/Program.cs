using Azure.Core;
using Azure.Identity;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

var credential = new DefaultAzureCredential(new DefaultAzureCredentialOptions
{
    ExcludeVisualStudioCredential = true
});

builder.Services.AddControllersWithViews();
builder.Configuration.AddAzureKeyVault(
    new Uri($"https://{builder.Configuration["KeyVaultName"]}.vault.azure.net/"), credential);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

app.MapGet("api/secret", (IConfiguration configuration) =>
{
    return configuration["ForgeClientId"];
});


app.MapGet("api/sql", async () =>
{
    using var conn =
    new SqlConnection("Server=tcp:sqlforgedemowf6edetest.database.windows.net,1433;Initial Catalog=FullstackOpdracht;");
    var token = await credential.GetTokenAsync(
        new TokenRequestContext(new[] { "https://database.windows.net/.default" }));
    conn.AccessToken = token.Token;
    await conn.OpenAsync();
    return "Sql Server Ready";

});

app.MapGet("api/forge", async (IConfiguration configuration) =>
{
    var client = new HttpClient
    {
        BaseAddress = new Uri("https://developer.api.autodesk.com/")
    };
    var keyvalue = new List<KeyValuePair<string, string>>
        {
            new("client_id", configuration["ForgeClientId"]),
            new("client_secret", configuration["ForgeClientSecret"]),
            new("grant_type", "client_credentials"),
            new("scope",
                "user-profile:read viewables:read data:read data:write data:create data:search bucket:create bucket:read bucket:update bucket:delete code:all account:read account:write")
        };
    var response = await client.PostAsync("/authentication/v1/authenticate", new FormUrlEncodedContent(keyvalue));
    response.EnsureSuccessStatusCode();
    var responseObject = JsonConvert.DeserializeObject<Authorization>(await response.Content.ReadAsStringAsync());
    return responseObject!.AccessToken;
});


app.MapControllerRoute(
    name: "default",
    pattern: "{controller}/{action=Index}/{id?}");


app.MapFallbackToFile("index.html"); ;

app.Run();


internal class Authorization
{
    [JsonProperty("access_token")]
    public string AccessToken { get; set; } = string.Empty;
    [JsonProperty("token_type")]
    public string TokenType { get; set; } = string.Empty;
    [JsonProperty("expires_in")]
    public int ExpiresIn { get; set; }
}