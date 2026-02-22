using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using QSmartBackend.Models;
using QSmartBackend.ViewModels;
using QSmartBackend.BLL;

namespace QSmartBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReadingController : ControllerBase
    {
        private readonly ReadingService _service;

        public ReadingController(ReadingService service)
        {
            _service = service;
        }

        // GET api/reading
        [Authorize]
        [HttpGet]
        public async Task<IActionResult> GetAllReadings()
        {
            var readings = await _service.GetAllReadingsAsync();
            return Ok(readings);
        }

        // GET api/reading/session/{sessionId}
        [Authorize]
        [HttpGet("session/{sessionId}")]
        public async Task<IActionResult> GetReadingsBySession(string sessionId)
        {
            if (string.IsNullOrWhiteSpace(sessionId))
            {
                return BadRequest(new { success = false, message = "SessionId is required." });
            }

            var readings = await _service.GetReadingsBySessionAsync(sessionId);
            if (readings == null || readings.Count == 0)
                return NotFound(new { success = false, message = $"No readings found for session ID: {sessionId}" });

            return Ok(readings);
        }

        // GET api/reading/{userId}/{sessionId}
        [Authorize]
        [HttpGet("{userId}/{sessionId}/{region}")]
        public async Task<IActionResult> GetReadingByUserAndSession(string userId, string sessionId, string region)
        {
            if (string.IsNullOrWhiteSpace(sessionId) || string.IsNullOrWhiteSpace(userId))
                return BadRequest(new { success = false, message = "SessionId and UserId are required fields." });

            var reading = await _service.GetReadingForRegionAsync(userId, sessionId, region);
            if (reading == null)
                return NotFound(new { success = false, message = $"No reading found for UserID: {userId} and SessionID: {sessionId} and Region: {region}" });

            return Ok(reading);
        }

        // POST api/reading
        [Authorize]
        [HttpPost]
        public async Task<IActionResult> AddReading([FromBody] ReadingEditView readingView)
        {
            // 1) DTO null
            if (readingView == null)
                return BadRequest(new { success = false, message = "Reading data is required." });

            // 2) DataAnnotations + ModelState validation
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                    .SelectMany(v => v.Errors)
                    .Select(e => e.ErrorMessage)
                    .ToList();

                return BadRequest(new { success = false, errors });
            }

            // update has record
            var existingReading = await _service.GetReadingForRegionAsync(readingView.UserId, readingView.SessionId, readingView.Region ?? string.Empty);

            if (existingReading != null)
            {
                existingReading.CreatedAt = readingView.CreatedAt ?? DateTime.UtcNow;
                existingReading.Region = readingView.Region;
                existingReading.TensionScore = readingView.TensionScore;
                existingReading.HeartRateBpm = readingView.HeartRateBpm;
                existingReading.PostureAngleDegree = readingView.PostureAngleDegree;
                existingReading.ActivityLabel = readingView.ActivityLabel;
                existingReading.SkinTempC = readingView.SkinTempC;
                existingReading.GsrUs = readingView.GsrUs;
                existingReading.RespirationBpm = readingView.RespirationBpm;
                existingReading.Spo2Pct = readingView.Spo2Pct;
                existingReading.EmgUv = readingView.EmgUv;
                existingReading.AccelXyz = readingView.AccelXyz;
                existingReading.GyroDps = readingView.GyroDps;
                existingReading.PressureKpa = readingView.PressureKpa;
                existingReading.AmbientTempC = readingView.AmbientTempC;
                existingReading.HumidityPct = readingView.HumidityPct;
                existingReading.NoiseDb = readingView.NoiseDb;
                existingReading.StressIndex = readingView.StressIndex;
                existingReading.CumulativeTensionLoad = readingView.CumulativeTensionLoad;
                existingReading.RecoveryScore = readingView.RecoveryScore;

                var updated = await _service.UpdateReadingAsync(existingReading);
                return Ok(updated); // 200 OK for update
            }

            // create if no record
            var newReading = new Reading
            {
                UserId = readingView.UserId,
                SessionId = readingView.SessionId,
                CreatedAt = readingView.CreatedAt ?? DateTime.UtcNow,
                Region = readingView.Region,
                TensionScore = readingView.TensionScore,
                HeartRateBpm = readingView.HeartRateBpm,
                PostureAngleDegree = readingView.PostureAngleDegree,
                ActivityLabel = readingView.ActivityLabel,
                SkinTempC = readingView.SkinTempC,
                GsrUs = readingView.GsrUs,
                RespirationBpm = readingView.RespirationBpm,
                Spo2Pct = readingView.Spo2Pct,
                EmgUv = readingView.EmgUv,
                AccelXyz = readingView.AccelXyz,
                GyroDps = readingView.GyroDps,
                PressureKpa = readingView.PressureKpa,
                AmbientTempC = readingView.AmbientTempC,
                HumidityPct = readingView.HumidityPct,
                NoiseDb = readingView.NoiseDb,
                StressIndex = readingView.StressIndex,
                CumulativeTensionLoad = readingView.CumulativeTensionLoad,
                RecoveryScore = readingView.RecoveryScore
            };

            var added = await _service.AddReadingAsync(newReading);
            return CreatedAtAction(nameof(GetReadingsBySession),
                new { sessionId = added.SessionId },
                added); // 201 Created
        }
    }
}
