using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using QSmartBackend.Models;

namespace QSmartBackend.Data
{
    public class AppDbContext : IdentityDbContext<AppUser>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options) { }

        public DbSet<Session> Sessions { get; set; }
        public DbSet<Reading> Readings { get; set; }
        
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Reading>()
                .HasKey(r => new { r.UserId, r.SessionId, r.Region });

            modelBuilder.Entity<Reading>()
                .HasOne(r => r.User) // Reading -> AppUser
                .WithMany() // AppUser has no Readings collection (or u => u.Readings if you added it)
                .HasForeignKey(r => r.UserId) // explicitly specify the FK
                .IsRequired();
        }
    }
}