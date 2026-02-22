using Microsoft.AspNetCore.Identity;

namespace QSmartBackend.Models
{
    public class AppUser : IdentityUser
    {
        public string FullName { get; set; } = string.Empty;
        public string Role { get; set; } = "Member";

        public virtual ICollection<Reading> Readings { get; set; } = new List<Reading>();
    }
}
