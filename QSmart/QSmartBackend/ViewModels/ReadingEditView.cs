using System;
using System.ComponentModel.DataAnnotations;

namespace QSmartBackend.ViewModels
{
    public class ReadingEditView
    {
        [Required(ErrorMessage = "UserId is required.")]
        public string UserId { get; set; } = string.Empty;

        [Required(ErrorMessage = "SessionId is required.")]
        public string SessionId { get; set; } = string.Empty;

        [Required(ErrorMessage = "CreatedAt is required.")]
        public DateTime? CreatedAt { get; set; }

        [Required(ErrorMessage = "Region is required.")]
        [StringLength(100, ErrorMessage = "Region cannot exceed 100 characters.")]
        public string Region { get; set; } = string.Empty;


        [Range(0, 100, ErrorMessage = "TensionScore must be between 0 and 100.")]
        public double? TensionScore { get; set; }

        [Range(20, 220, ErrorMessage = "HeartRateBpm must be between 20 and 220.")]
        public double? HeartRateBpm { get; set; }

        [Range(0, 180, ErrorMessage = "PostureAngleDegree must be between 0 and 180.")]
        public double? PostureAngleDegree { get; set; }

        [StringLength(100, ErrorMessage = "ActivityLabel cannot exceed 100 characters.")]
        public string? ActivityLabel { get; set; }

        [Range(20, 45, ErrorMessage = "SkinTempC must be between 20 and 45.")]
        public double? SkinTempC { get; set; }

        [Range(0, 10000, ErrorMessage = "GsrUs must be between 0 and 10000.")]
        public double? GsrUs { get; set; }

        [Range(5, 40, ErrorMessage = "RespirationBpm must be between 5 and 40.")]
        public double? RespirationBpm { get; set; }

        [Range(50, 100, ErrorMessage = "Spo2Pct must be between 50 and 100.")]
        public double? Spo2Pct { get; set; }

        [Range(0, 5000, ErrorMessage = "EmgUv must be between 0 and 5000.")]
        public double? EmgUv { get; set; }

        [StringLength(100, ErrorMessage = "AccelXyz cannot exceed 100 characters.")]
        public string? AccelXyz { get; set; }

        [StringLength(100, ErrorMessage = "GyroDps cannot exceed 100 characters.")]
        public string? GyroDps { get; set; }

        [Range(80, 200, ErrorMessage = "PressureKpa must be between 80 and 200.")]
        public double? PressureKpa { get; set; }

        [Range(-30, 60, ErrorMessage = "AmbientTempC must be between -30 and 60.")]
        public double? AmbientTempC { get; set; }

        [Range(0, 100, ErrorMessage = "HumidityPct must be between 0 and 100.")]
        public double? HumidityPct { get; set; }

        [Range(0, 150, ErrorMessage = "NoiseDb must be between 0 and 150.")]
        public double? NoiseDb { get; set; }

        [Range(0, 100, ErrorMessage = "StressIndex must be between 0 and 100.")]
        public double? StressIndex { get; set; }

        [Range(0, 10000, ErrorMessage = "CumulativeTensionLoad must be between 0 and 10000.")]
        public double? CumulativeTensionLoad { get; set; }

        [Range(0, 100, ErrorMessage = "RecoveryScore must be between 0 and 100.")]
        public double? RecoveryScore { get; set; }
    }
}
