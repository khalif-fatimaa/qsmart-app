using System.Text.Json.Serialization;

namespace qSmartWebDashboard.Models
{
    public class Reading
    {
        [JsonPropertyName("userId")]
        public string UserId { get; set; } = "";

        [JsonPropertyName("sessionId")]
        public string SessionId { get; set; } = "";

        [JsonPropertyName("createdAt")]
        public DateTime? CreatedAt { get; set; }

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

        [JsonPropertyName("recoveryScore")]
        public double? RecoveryScore { get; set; }

        [JsonPropertyName("stressIndex")]
        public double? StressIndex { get; set; }

        [JsonPropertyName("skinTempC")]
        public double? SkinTempC { get; set; }

        [JsonPropertyName("gsrUs")]
        public double? GsrUs { get; set; }

        [JsonPropertyName("respirationBpm")]
        public double? RespirationBpm { get; set; }

        [JsonPropertyName("spo2Pct")]
        public double? Spo2Pct { get; set; }

        [JsonPropertyName("emgUv")]
        public double? EmgUv { get; set; }

        [JsonPropertyName("accelXyz")]
        public string? AccelXyz { get; set; }

        [JsonPropertyName("gyroDps")]
        public string? GyroDps { get; set; }

        [JsonPropertyName("pressureKpa")]
        public double? PressureKpa { get; set; }

        [JsonPropertyName("ambientTempC")]
        public double? AmbientTempC { get; set; }

        [JsonPropertyName("humidityPct")]
        public double? HumidityPct { get; set; }

        [JsonPropertyName("noiseDb")]
        public double? NoiseDb { get; set; }

        [JsonPropertyName("cumulativeTensionLoad")]
        public double? CumulativeTensionLoad { get; set; }
    }
}