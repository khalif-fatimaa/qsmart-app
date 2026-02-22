using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QSmartBackend.Data;
using QSmartBackend.Models;

namespace QSmartBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AdminController : ControllerBase
    {

        private readonly UserManager<AppUser> _userManager;
        private readonly QSmartDBContext _dataDb;

        public AdminController(
            UserManager<AppUser> userManager,
            QSmartDBContext dataDb)
        {

            _userManager = userManager;
            _dataDb = dataDb;

        }

        // GET: /api/Admin/users
        [HttpGet("users")]
        public async Task<ActionResult<IEnumerable<object>>> GetUsers()
        {
            var users = await _userManager.Users
                .OrderBy(u => u.Email)
                .Select(u => new
                {
                    u.Id,

                    u.FullName,
                    u.UserName,
                    u.Email,
                    u.Role,
                    CreatedAt = (DateTime?)null
                })
                .ToListAsync();

            return Ok(users);
        }

        // GET: /api/Admin/users/{id}
        [HttpGet("users/{id}")]
        public async Task<ActionResult<object>> GetUserById(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            return Ok(new
            {
                user.Id,
                user.Email,
                user.FullName,
                user.Role
            });
        }

        // GET: /api/Admin/users/{userId}/sessions
        [HttpGet("users/{userId}/sessions")]
        public async Task<ActionResult<IEnumerable<object>>> GetSessionsByUser(string userId)
        {
            // Check if user exists
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                return NotFound($"User with ID {userId} not found");
            }

            // Get sessions from QSmartDB
            var sessions = await _dataDb.Sessions
                .Where(s => s.UserId == userId)
                .Select(s => new
                {
                    s.SessionId,
                    s.UserId,
                    s.StartedAt,
                    s.Notes,
                    s.Region,
                    s.TensionScore,
                    s.HeartRateBpm,
                    s.PostureAngleDegree,
                    s.ActivityLabel,
                    ReadingsCount = _dataDb.Readings.Count(r => r.SessionId == s.SessionId)
                })
                .OrderByDescending(s => s.StartedAt)
                .ToListAsync();

            return Ok(sessions);
        }

        // GET: /api/Admin/users/{userId}/sessions/{sessionId}/readings
        [HttpGet("users/{userId}/sessions/{sessionId}/readings")]
        public async Task<ActionResult<IEnumerable<Reading>>> GetReadingsForUserSession(string userId, string sessionId)
        {
            // Check if user exists
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                return NotFound($"User with ID {userId} not found");
            }

            // Verify the session belongs to the user
            var session = await _dataDb.Sessions
                .FirstOrDefaultAsync(s => s.SessionId == sessionId && s.UserId == userId);

            if (session == null)
            {
                return NotFound($"Session {sessionId} not found for user {userId}");
            }

            var readings = await _dataDb.Readings
                .Where(r => r.SessionId == sessionId)
                .OrderBy(r => r.Region)
                .ToListAsync();

            return Ok(readings);
        }

        // GET: /api/Admin/sessions
        [HttpGet("sessions")]
        public async Task<ActionResult<IEnumerable<object>>> GetSessions()
        {
            var sessions = await _dataDb.Sessions
                .Join(_userManager.Users,





                    s => s.UserId,
                    u => u.Id,
                    (s, u) => new
                    {
                        s.SessionId,
                        s.UserId,
                        UserFullName = u.FullName,
                        u.Email,
                        s.StartedAt,
                        s.Notes,
                        s.Region
                    })
                .ToListAsync();

            return Ok(sessions);
        }

        // GET: /api/Admin/sessions/{sessionId}/readings
        [HttpGet("sessions/{sessionId}/readings")]
        public async Task<ActionResult<IEnumerable<Reading>>> GetReadingsForSession(string sessionId)
        {
            var exists = await _dataDb.Sessions.AnyAsync(s => s.SessionId == sessionId);





            if (!exists)
            {
                return NotFound();
            }

            var readings = await _dataDb.Readings
                .Where(r => r.SessionId == sessionId)
                .ToListAsync();

            return Ok(readings);
        }

        // POST: /api/Admin/register-admin
        [HttpPost("register-admin")]
        public async Task<IActionResult> RegisterAdmin([FromBody] RegisterAdminRequest request)
        {
            // Check if user already exists
            var existingUser = await _userManager.FindByEmailAsync(request.Email);
            if (existingUser != null)
            {
                return BadRequest(new { message = "User already exists" });
            }

            // Create user
            var user = new AppUser
            {
                UserName = request.Email,
                Email = request.Email,
                FullName = request.FullName,
                Role = "Admin"
            };

            var result = await _userManager.CreateAsync(user, request.Password);

            if (result.Succeeded)
            {
                return Ok(new { message = $"Admin user created: {request.Email}" });
            }

            return BadRequest(result.Errors);
        }

        public class RegisterAdminRequest
        {
            public string Email { get; set; } = "";
            public string Password { get; set; } = "";
            public string FullName { get; set; } = "";
        }
    }
}