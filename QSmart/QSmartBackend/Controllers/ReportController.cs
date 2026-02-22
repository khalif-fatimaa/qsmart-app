using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using QSmartBackend.BLL;
using QSmartBackend.Models;
using QuestPDF.Fluent;
using QuestPDF.Infrastructure;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using QuestPdfDocument = QuestPDF.Fluent.Document;
using QuestPDF.Helpers;

namespace QSmartBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReportController : ControllerBase
    {
        private readonly SessionService _sessionService;
        private readonly ReadingService _readingService;
        private readonly UserManager<AppUser> _userManager;
        private readonly IWebHostEnvironment _env;

        public ReportController(
            SessionService sessionService,
            ReadingService readingService,
            UserManager<AppUser> userManager,
            IWebHostEnvironment env)
        {
            _sessionService = sessionService;
            _readingService = readingService;
            _userManager = userManager;
            _env = env;
        }

        [HttpGet("userprogress/{userId}")]
        public async Task<IActionResult> GetUserProgressPdf(string userId, [FromQuery] string? sessionId = null)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
                return NotFound("User not found.");

            var sessions = await _sessionService.GetSessionsByUserAsync(userId);

            if (!string.IsNullOrWhiteSpace(sessionId))
                sessions = sessions.Where(s => s.SessionId == sessionId).ToList();

            if (sessions == null || sessions.Count == 0)
                return NotFound("No sessions found for this user.");

            var readingsBySession = new Dictionary<string, List<Reading>>();

            foreach (var session in sessions)
            {
                var readings = await _readingService.GetReadingsBySessionAsync(session.SessionId);
                readingsBySession[session.SessionId] = readings ?? new List<Reading>();
            }

            byte[]? logoBytes = null;
            try
            {
                var logoPath = Path.Combine(_env.WebRootPath ?? string.Empty, "images", "qsmart-logo.png");
                if (System.IO.File.Exists(logoPath))
                    logoBytes = System.IO.File.ReadAllBytes(logoPath);
            }
            catch
            {
            }

            var pdfBytes = BuildUserProgressPdf(user, sessions, readingsBySession, logoBytes);

            var scopeSuffix = string.IsNullOrWhiteSpace(sessionId) ? "all" : sessionId;
            var safeName = string.IsNullOrWhiteSpace(user.FullName) ? user.Email : user.FullName;
            var fileName = $"user-progress-{safeName}-{scopeSuffix}-{DateTime.UtcNow:yyyyMMddHHmm}.pdf";

            return File(pdfBytes, "application/pdf", fileName);
        }

        private static byte[] BuildUserProgressPdf(
            AppUser user,
            List<Session> sessions,
            Dictionary<string, List<Reading>> readingsBySession,
            byte[]? logoBytes)
        {
            QuestPDF.Settings.License = LicenseType.Community;

            var allReadings = new List<Reading>();
            var sessionSummaries = new List<SessionSummary>();

            foreach (var s in sessions)
            {
                if (!readingsBySession.TryGetValue(s.SessionId, out var rList) || rList == null)
                    rList = new List<Reading>();

                allReadings.AddRange(rList);

                var count = rList.Count;
                double? avgTension = count > 0 ? rList.Where(r => r.TensionScore.HasValue).Select(r => (double)r.TensionScore!.Value).DefaultIfEmpty().Average() : null;
                double? avgHeart = count > 0 ? rList.Where(r => r.HeartRateBpm.HasValue).Select(r => (double)r.HeartRateBpm!.Value).DefaultIfEmpty().Average() : null;
                double? avgRecovery = count > 0 ? rList.Where(r => r.RecoveryScore.HasValue).Select(r => (double)r.RecoveryScore!.Value).DefaultIfEmpty().Average() : null;
                double? avgStress = count > 0 ? rList.Where(r => r.StressIndex.HasValue).Select(r => (double)r.StressIndex!.Value).DefaultIfEmpty().Average() : null;

                sessionSummaries.Add(new SessionSummary
                {
                    Session = s,
                    ReadingCount = count,
                    AvgTension = avgTension,
                    AvgHeartRate = avgHeart,
                    AvgRecovery = avgRecovery,
                    AvgStress = avgStress
                });
            }

            var totalSessions = sessions.Count;
            var totalReadings = allReadings.Count;

            double? overallAvgTension = totalReadings > 0
                ? allReadings.Where(r => r.TensionScore.HasValue).Select(r => (double)r.TensionScore!.Value).DefaultIfEmpty().Average()
                : null;

            double? overallAvgHeart = totalReadings > 0
                ? allReadings.Where(r => r.HeartRateBpm.HasValue).Select(r => (double)r.HeartRateBpm!.Value).DefaultIfEmpty().Average()
                : null;

            double? overallAvgRecovery = totalReadings > 0
                ? allReadings.Where(r => r.RecoveryScore.HasValue).Select(r => (double)r.RecoveryScore!.Value).DefaultIfEmpty().Average()
                : null;

            double? overallAvgStress = totalReadings > 0
                ? allReadings.Where(r => r.StressIndex.HasValue).Select(r => (double)r.StressIndex!.Value).DefaultIfEmpty().Average()
                : null;

            var sessionsWithTension = sessionSummaries.Where(x => x.ReadingCount > 0 && x.AvgTension.HasValue).ToList();
            var highestTensionSession = sessionsWithTension.OrderByDescending(x => x.AvgTension).FirstOrDefault();
            var lowestTensionSession = sessionsWithTension.OrderBy(x => x.AvgTension).FirstOrDefault();

            var topRegions = allReadings
                .Where(r => !string.IsNullOrWhiteSpace(r.Region))
                .GroupBy(r => r.Region!)
                .OrderByDescending(g => g.Count())
                .Take(3)
                .Select(g => g.Key)
                .ToList();

            var mostCommonRegions = topRegions.Any() ? string.Join(", ", topRegions) : "-";

            // single vs all-sessions flag
            var isSingleSession = sessions.Count == 1;

            var pdfBytes = QuestPdfDocument.Create(container =>
            {
                container.Page(page =>
                {
                    // landscape A4
                    page.Size(PageSizes.A4.Landscape());
                    page.Margin(40);

                    page.Header().Row(row =>
                    {
                        if (logoBytes != null && logoBytes.Length > 0)
                        {
                            row.ConstantItem(90).Height(40).Image(logoBytes);
                        }
                        else
                        {
                            row.ConstantItem(90)
                                .Text("QSMART")
                                .FontSize(18)
                                .SemiBold();
                        }

                        row.RelativeItem().AlignRight().Column(col =>
                        {
                            col.Item().Text("User Progress Report").FontSize(18).SemiBold();
                            col.Item().Text(user.FullName ?? user.Email).FontSize(11);
                            col.Item().Text($"Generated: {DateTime.UtcNow:yyyy-MM-dd HH:mm} UTC").FontSize(9);
                        });
                    });

                    page.Content().Column(col =>
                    {
                        col.Item().PaddingBottom(6).Text(text =>
                        {
                            text.Span("Email: ").SemiBold();
                            text.Span(user.Email);
                        });

                        col.Item().PaddingBottom(10).Text(text =>
                        {
                            text.Span("Total Sessions: ").SemiBold();
                            text.Span(totalSessions.ToString());
                        });

                        col.Item().PaddingBottom(10).Text(text =>
                        {
                            text.Span("Total Readings: ").SemiBold();
                            text.Span(totalReadings.ToString());
                        });

                        col.Item().PaddingTop(10).PaddingBottom(6)
                            .Text("Overall Progress Summary")
                            .FontSize(14)
                            .SemiBold();

                        col.Item().PaddingBottom(10).Text(text =>
                        {
                            text.Line($"Average Tension Score: {FormatDouble(overallAvgTension)}");
                            text.Line($"Average Heart Rate: {FormatDouble(overallAvgHeart)} bpm");
                            text.Line($"Average Recovery Score: {FormatDouble(overallAvgRecovery)}");
                            text.Line($"Average Stress Index: {FormatDouble(overallAvgStress)}");
                            text.Line($"Highest Tension Session: {FormatSessionSummary(highestTensionSession)}");
                            text.Line($"Lowest Tension Session: {FormatSessionSummary(lowestTensionSession)}");
                            text.Line($"Most Common Regions Treated: {mostCommonRegions}");
                        });

                        col.Item().PaddingTop(10).PaddingBottom(6)
                            .Text("Session Summary")
                            .FontSize(14)
                            .SemiBold();

                        // session summary table
                        col.Item().Table(table =>
                        {
                            table.ColumnsDefinition(cols =>
                            {
                                cols.RelativeColumn(2);
                                cols.RelativeColumn(3);
                                cols.RelativeColumn(3);
                                cols.RelativeColumn(2);
                                cols.RelativeColumn(2);
                                cols.RelativeColumn(2);
                            });

                            table.Header(header =>
                            {
                                header.Cell().Text("Session ID").SemiBold();
                                header.Cell().Text("Start Time (Local)").SemiBold();
                                header.Cell().Text("Region").SemiBold();
                                header.Cell().Text("Avg Tension").SemiBold();
                                header.Cell().Text("Avg Heart Rate").SemiBold();
                                header.Cell().Text("Readings").SemiBold();
                            });

                            foreach (var s in sessionSummaries.OrderBy(x => x.Session.StartedAt))
                            {
                                var session = s.Session;
                                var region = session.Region ?? "-";
                                var startLocal = session.StartedAt.HasValue
                                    ? session.StartedAt.Value.ToLocalTime().ToString("yyyy-MM-dd HH:mm")
                                    : "-";

                                var shortId = !string.IsNullOrEmpty(session.SessionId) && session.SessionId.Length > 8
                                    ? session.SessionId[..8]
                                    : session.SessionId;

                                table.Cell().Text(shortId);
                                table.Cell().Text(startLocal);
                                table.Cell().Text(region);
                                table.Cell().Text(FormatDouble(s.AvgTension));
                                table.Cell().Text(s.AvgHeartRate.HasValue ? $"{s.AvgHeartRate.Value:0.0} bpm" : "-");
                                table.Cell().Text(s.ReadingCount.ToString());
                            }
                        });

                        // per-session sections
                        foreach (var sSummary in sessionSummaries.OrderBy(x => x.Session.StartedAt))
                        {
                            var session = sSummary.Session;

                            var shortId = !string.IsNullOrEmpty(session.SessionId) && session.SessionId.Length > 8
                                ? session.SessionId[..8]
                                : session.SessionId;

                            col.Item().PaddingTop(20).Text(text =>
                            {
                                text.DefaultTextStyle(x => x.FontSize(13));
                                text.Span("Session Details – ").SemiBold();
                                text.Span(shortId);
                            });

                            col.Item().Text(text =>
                            {
                                text.Line($"Started: {session.StartedAt?.ToLocalTime().ToString("yyyy-MM-dd HH:mm") ?? "-"}");
                                text.Line($"Region: {session.Region ?? "-"}");
                                text.Line($"Notes: {session.Notes ?? "-"}");
                            });

                            col.Item().PaddingTop(4).Text(text =>
                            {
                                text.Line($"Average Tension Score: {FormatDouble(sSummary.AvgTension)}");
                                text.Line($"Average Heart Rate: {FormatDouble(sSummary.AvgHeartRate)} bpm");
                                text.Line($"Average Recovery Score: {FormatDouble(sSummary.AvgRecovery)}");
                                text.Line($"Average Stress Index: {FormatDouble(sSummary.AvgStress)}");
                                text.Line($"Total Readings: {sSummary.ReadingCount}");
                            });

                            if (!readingsBySession.TryGetValue(session.SessionId, out var readings) ||
                                readings == null || readings.Count == 0)
                            {
                                col.Item().PaddingTop(4).Text("No readings for this session.");
                                continue;
                            }

                            // Only show the giant per-reading table on single-session exports
                            if (!isSingleSession)
                                continue;

                            col.Item().PaddingTop(6).Table(table =>
                            {
                                table.ColumnsDefinition(cols =>
                                {
                                    cols.RelativeColumn(2);  // Timestamp 
                                    cols.RelativeColumn();   // Region
                                    cols.RelativeColumn();   // Activity
                                    cols.RelativeColumn();   // Tension
                                    cols.RelativeColumn();   // Heart Rate
                                    cols.RelativeColumn();   // Posture
                                    cols.RelativeColumn();   // Recovery
                                    cols.RelativeColumn();   // Stress
                                    cols.RelativeColumn();   // Skin Temp
                                    cols.RelativeColumn();   // GSR
                                    cols.RelativeColumn();   // Respiration
                                    cols.RelativeColumn();   // SpO2
                                    cols.RelativeColumn();   // EMG
                                    cols.RelativeColumn();   // Accel
                                    cols.RelativeColumn();   // Gyro
                                    cols.RelativeColumn();   // Pressure
                                    cols.RelativeColumn();   // Ambient Temp
                                    cols.RelativeColumn();   // Humidity
                                    cols.RelativeColumn();   // Noise
                                    cols.RelativeColumn();   // Cumulative Load
                                });

                                table.Header(header =>
                                {
                                    header.Cell().Text("Timestamp").SemiBold();
                                    header.Cell().Text("Region").SemiBold();
                                    header.Cell().Text("Activity").SemiBold();
                                    header.Cell().Text("Tension Score").SemiBold();
                                    header.Cell().Text("Heart Rate").SemiBold();
                                    header.Cell().Text("Posture Angle").SemiBold();
                                    header.Cell().Text("Recovery Score").SemiBold();
                                    header.Cell().Text("Stress Index").SemiBold();
                                    header.Cell().Text("Skin Temp").SemiBold();
                                    header.Cell().Text("GSR").SemiBold();
                                    header.Cell().Text("Respiration").SemiBold();
                                    header.Cell().Text("SpO2").SemiBold();
                                    header.Cell().Text("EMG").SemiBold();
                                    header.Cell().Text("Accel").SemiBold();
                                    header.Cell().Text("Gyro").SemiBold();
                                    header.Cell().Text("Pressure").SemiBold();
                                    header.Cell().Text("Ambient Temp").SemiBold();
                                    header.Cell().Text("Humidity").SemiBold();
                                    header.Cell().Text("Noise").SemiBold();
                                    header.Cell().Text("Cumulative Load").SemiBold();
                                });

                                foreach (var r in readings.OrderBy(r => r.CreatedAt))
                                {
                                    var time = r.CreatedAt?.ToLocalTime().ToString("yyyy-MM-dd HH:mm") ?? "-";

                                    table.Cell().Text(time);
                                    table.Cell().Text(r.Region ?? "-");
                                    table.Cell().Text(r.ActivityLabel ?? "-");

                                    table.Cell().Text(r.TensionScore.HasValue ? r.TensionScore.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.HeartRateBpm.HasValue ? r.HeartRateBpm.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.PostureAngleDegree.HasValue ? r.PostureAngleDegree.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.RecoveryScore.HasValue ? r.RecoveryScore.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.StressIndex.HasValue ? r.StressIndex.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.SkinTempC.HasValue ? r.SkinTempC.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.GsrUs.HasValue ? r.GsrUs.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.RespirationBpm.HasValue ? r.RespirationBpm.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.Spo2Pct.HasValue ? r.Spo2Pct.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.EmgUv.HasValue ? r.EmgUv.Value.ToString("0.0") : "-");

                                    table.Cell().Text(string.IsNullOrWhiteSpace(r.AccelXyz) ? "-" : r.AccelXyz);
                                    table.Cell().Text(string.IsNullOrWhiteSpace(r.GyroDps) ? "-" : r.GyroDps);

                                    table.Cell().Text(r.PressureKpa.HasValue ? r.PressureKpa.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.AmbientTempC.HasValue ? r.AmbientTempC.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.HumidityPct.HasValue ? r.HumidityPct.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.NoiseDb.HasValue ? r.NoiseDb.Value.ToString("0.0") : "-");
                                    table.Cell().Text(r.CumulativeTensionLoad.HasValue ? r.CumulativeTensionLoad.Value.ToString("0.0") : "-");
                                }
                            });
                        }
                    });

                    page.Footer()
                        .AlignCenter()
                        .Text(text =>
                        {
                            text.DefaultTextStyle(x => x.FontSize(9));
                            text.Span("QSMART – Smart Massage Chair Dashboard");
                            text.Line($"Generated {DateTime.UtcNow:yyyy-MM-dd HH:mm} (UTC)");
                        });
                });
            }).GeneratePdf();

            return pdfBytes;
        }

        private static string FormatDouble(double? value)
        {
            return value.HasValue ? value.Value.ToString("0.0") : "-";
        }

        private static string FormatSessionSummary(SessionSummary? summary)
        {
            if (summary == null || summary.Session == null || !summary.AvgTension.HasValue)
                return "-";

            var id = summary.Session.SessionId;
            if (!string.IsNullOrEmpty(id) && id.Length > 8)
                id = id[..8];

            var avg = summary.AvgTension.Value.ToString("0.0");
            return $"{id} ({avg})";
        }

        private class SessionSummary
        {
            public Session Session { get; set; } = default!;
            public int ReadingCount { get; set; }
            public double? AvgTension { get; set; }
            public double? AvgHeartRate { get; set; }
            public double? AvgRecovery { get; set; }
            public double? AvgStress { get; set; }
        }
    }
}
