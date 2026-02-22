using System.Text.Json.Serialization;

namespace qSmartWebDashboard.Models;

public class User
{
    [JsonPropertyName("id")]
    public string Id { get; set; } = "";

    [JsonPropertyName("fullName")]
    public string FullName { get; set; } = "";

    [JsonPropertyName("userName")]
    public string UserName { get; set; } = "";

    [JsonPropertyName("email")]
    public string Email { get; set; } = "";

    [JsonPropertyName("role")]
    public string Role { get; set; } = "";

    [JsonPropertyName("createdAt")]
    public DateTimeOffset? CreatedAt { get; set; }

    public string user_id => Id;
    public string name => FullName;
    public string email => Email;
    public DateTime created_at => CreatedAt?.DateTime ?? DateTime.MinValue;
}