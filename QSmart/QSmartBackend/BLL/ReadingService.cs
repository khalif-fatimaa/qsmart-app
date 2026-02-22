using Microsoft.EntityFrameworkCore;

using QSmartBackend.Models;

namespace QSmartBackend.BLL
{
    public class ReadingService
    {
        private readonly QSmartDBContext _context;

        public ReadingService(QSmartDBContext context)
        {
            _context = context;
        }

        // Get all readings
        public async Task<List<Reading>> GetAllReadingsAsync()
        {
            return await _context.Readings
                .ToListAsync();
        }

        // Get readings by session
        public async Task<List<Reading>> GetReadingsBySessionAsync(string sessionId)
        {
            return await _context.Readings
                .Where(r => r.SessionId == sessionId)
                .ToListAsync();
        }
        
        // Get a single reading by UserId + SessionId (composite key) + Region
        public async Task<Reading?> GetReadingForRegionAsync(string userId, string sessionId, string region)
        {
            return await _context.Readings
                .FirstOrDefaultAsync(r => r.UserId == userId && r.SessionId == sessionId && r.Region == region);
        }
        
        public async Task<Reading> UpdateReadingAsync(Reading reading)
        {
            _context.Readings.Update(reading);
            await _context.SaveChangesAsync();
            return reading;
        } 

        // Add new reading
        public async Task<Reading> AddReadingAsync(Reading reading)
        {
            _context.Readings.Add(reading);
            await _context.SaveChangesAsync();
            return reading;
        }
    }
}

