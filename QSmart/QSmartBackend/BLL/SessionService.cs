using Microsoft.EntityFrameworkCore;
using QSmartBackend.Models;

namespace QSmartBackend.BLL
{
    public class SessionService
    {
        private readonly QSmartDBContext _context;

        public SessionService(QSmartDBContext context)
        {
            _context = context;
        }

        // Get all sessions with user info
        public async Task<List<Session>> GetAllSessionsAsync()
        {
            return await _context.Sessions
                .ToListAsync();
        }

        // Get sessions by user ID
        public async Task<List<Session>> GetSessionsByUserAsync(string userId)
        {
            return await _context.Sessions
                .Where(s => s.UserId == userId)
                .ToListAsync();
        }

        // Add a new session
        public async Task<Session> AddSessionAsync(Session session)
        {
            _context.Sessions.Add(session);
            await _context.SaveChangesAsync();
            return session;
        }

        // Delete a session
        public async Task<bool> DeleteSessionAsync(string sessionId)
        {
            var session = await _context.Sessions.FindAsync(sessionId);
            if (session == null) return false;

            _context.Sessions.Remove(session);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}

