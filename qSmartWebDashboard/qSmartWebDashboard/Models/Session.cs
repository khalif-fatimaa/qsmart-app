using System.Text.Json.Serialization;

namespace qSmartWebDashboard.Models;

public class Session
{
    [JsonPropertyName("sessionId")]
    public string SessionId { get; set; } = "";

    [JsonPropertyName("userId")]
    public string UserId { get; set; } = "";

    [JsonPropertyName("startedAt")]
    public DateTime? StartedAt { get; set; }

    [JsonPropertyName("notes")]
    public string? Notes { get; set; }

    [JsonPropertyName("region")]
    public string Region { get; set; } = "";

    [JsonPropertyName("tensionScore")]
    public double? TensionScore { get; set; }

    [JsonPropertyName("heartRateBpm")]
    public double? HeartRateBpm { get; set; }

    [JsonPropertyName("postureAngleDegree")]
    public double? PostureAngleDegree { get; set; }

    [JsonPropertyName("activityLabel")]
    public string ActivityLabel { get; set; } = "";

    // These are just convenience aliases for old mock JSON.
    // Mark them as JsonIgnore so they don't collide with the main properties.

    [JsonIgnore]
    public string session_id => SessionId;

    [JsonIgnore]
    public string user_id => UserId;

    [JsonIgnore]
    public DateTime started_at => StartedAt ?? DateTime.MinValue;

    [JsonIgnore]
    public string notes => Notes ?? "";
}