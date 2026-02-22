using Microsoft.AspNetCore.Mvc;
using QSmartBackend.Models;
using QSmartBackend.ViewModels;
using QSmartBackend.BLL;
using System.Linq;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;

namespace QSmartBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class SessionController : ControllerBase
    {
        private readonly SessionService _service;

        public SessionController(SessionService service)
        {
            _service = service;
        }

        // GET: api/session
        [HttpGet]
        public async Task<IActionResult> GetAllSessions()
        {
            var sessions = await _service.GetAllSessionsAsync();
            return Ok(sessions);
        }

        // GET: api/session/user/{userId}
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetSessionsByUser(string userId)
        {
            if (string.IsNullOrWhiteSpace(userId))
            {
                return BadRequest(new
                {
                    success = false,
                    message = "UserID is required."
                });
            }

            var sessions = await _service.GetSessionsByUserAsync(userId);
            return Ok(sessions);
        }

        // POST: api/session
        [HttpPost]
        public async Task<IActionResult> CreateSession([FromBody] SessionEditView sessionEditView)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userId is null)
            {
                return BadRequest("User not found.");
            }
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                    .SelectMany(v => v.Errors)
                    .Select(e => e.ErrorMessage)
                    .ToList();

                return BadRequest(new
                {
                    success = false,
                    errors
                });
            }

            var session = new Session
            {
                SessionId = Guid.NewGuid().ToString(),
                UserId = userId,
                StartedAt = sessionEditView.StartedAt,
                Notes = sessionEditView.Notes,
                Region = sessionEditView.Region,
                TensionScore = sessionEditView.TensionScore,
                HeartRateBpm = sessionEditView.HeartRateBpm,
                PostureAngleDegree = sessionEditView.PostureAngleDegree,
                ActivityLabel = sessionEditView.ActivityLabel
            };

            var created = await _service.AddSessionAsync(session);

            return CreatedAtAction(nameof(GetAllSessions),
                new { id = created.SessionId },
                created);
        }

        // DELETE: api/session/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSession(string id)
        {
            if (string.IsNullOrWhiteSpace(id))
            {
                return BadRequest(new
                {
                    success = false,
                    message = "Session id is required."
                });
            }

            var deleted = await _service.DeleteSessionAsync(id);

            if (!deleted)
            {
                return NotFound(new
                {
                    success = false,
                    message = "Session not found."
                });
            }

            return NoContent();
        }
    }
}
