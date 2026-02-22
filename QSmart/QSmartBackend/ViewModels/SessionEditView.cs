using System.ComponentModel.DataAnnotations;

namespace QSmartBackend.ViewModels
{
    public class SessionEditView
    {
        public string? SessionID { get; set; }

        [Required(ErrorMessage = "UserID is required.")]
        public string UserID { get; set; }

        [Required(ErrorMessage = "StartedAt is required.")]
        public DateTime? StartedAt { get; set; }

        public string? Notes { get; set; }

        [Required(ErrorMessage = "Region is required.")]
        public string Region { get; set; }

        [Range(0, 100, ErrorMessage = "TensionScore must be between 0 and 100.")]
        public double? TensionScore { get; set; }

        [Range(30, 220, ErrorMessage = "HeartRateBpm must be between 30 and 220.")]
        public double? HeartRateBpm { get; set; }

        [Range(0, 180, ErrorMessage = "PostureAngleDegree must be between 0 and 180.")]
        public double? PostureAngleDegree { get; set; }

        [Required(ErrorMessage = "ActivityLabel is required.")]
        public string ActivityLabel { get; set; }
    }
}
