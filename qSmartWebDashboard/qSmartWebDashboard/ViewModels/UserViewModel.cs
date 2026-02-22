namespace qSmartWebDashboard.ViewModels;

public class UserViewModel
{
    public string Id { get; set; } = "";
    public string FullName { get; set; } = "";
    public string UserName { get; set; } = "";
    public string Email { get; set; } = "";
    public string Role { get; set; } = "";
    public DateTimeOffset? CreatedAt { get; set; } = DateTime.UtcNow;
}

public class RegisterViewModel
{
    public string FullName { get; set; } = "";
    public string Email { get; set; } = "";
    public string Password { get; set; } = "";
}

public class LoginViewModel
{
    public string Email { get; set; } = "";
    public string Password { get; set; } = "";
}