using qSmartWebDashboard.Models;
using qSmartWebDashboard.ViewModels;
using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.AspNetCore.Components;
using System.Net;
using System.Net.Http.Headers;

namespace qSmartWebDashboard.Data
{
    public class ApiDataService
    {
        private readonly HttpClient _httpClient;
        private readonly NavigationManager _navigationManager;

        public ApiDataService(HttpClient httpClient, NavigationManager navigationManager)
        {
            _httpClient = httpClient;
            _navigationManager = navigationManager;

            if (_httpClient.BaseAddress == null)
            {
                _httpClient.BaseAddress = new Uri("http://localhost:5111");
            }
        }

        // =============================================================
        // USERS
        // =============================================================

        // GET: api/admin/users
        public async Task<List<UserViewModel>> GetUsersAsync()
        {
            try
            {
                Console.WriteLine("Fetching users from api/admin/users ...");

                var response = await _httpClient.GetAsync("api/admin/users");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Users API Response: {content}");

                    var options = new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true
                    };

                    var users = JsonSerializer.Deserialize<List<UserViewModel>>(content, options);

                    if (users == null)
                    {
                        Console.WriteLine("Users list is null after deserialization.");
                        return new List<UserViewModel>();
                    }

                    Console.WriteLine($"Successfully deserialized {users.Count} users.");
                    return users;
                }
                else if (response.StatusCode == HttpStatusCode.Unauthorized)
                {
                    Console.WriteLine("Unauthorized when fetching users. Redirecting to /login.");
                    _navigationManager.NavigateTo("/login");
                    return new List<UserViewModel>();
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Failed to get users. Status: {response.StatusCode}, Error: {errorContent}");
                    return new List<UserViewModel>();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching users: {ex.Message}");
                return new List<UserViewModel>();
            }
        }

        // GET: api/user/{id}
        public async Task<UserViewModel?> GetUserByIdAsync(string id)
        {
            try
            {
                var response = await _httpClient.GetAsync($"api/admin/users/{id}");

                if (response.IsSuccessStatusCode)
                {
                    var options = new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true
                    };

                    var content = await response.Content.ReadAsStringAsync();
                    return JsonSerializer.Deserialize<UserViewModel>(content, options);
                }

                Console.WriteLine($"GetUserByIdAsync failed. Status: {response.StatusCode}");
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching user by ID: {ex.Message}");
                return null;
            }
        }

        // POST: api/users
        public async Task<(bool Success, string Message, UserViewModel? User)> CreateUserAsync(CreateUserRequest request)
        {
            try
            {
                Console.WriteLine($"Creating user: {request.Email}");

                var response = await _httpClient.PostAsJsonAsync("api/user", request);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<CreateUserResult>();
                    return (true, result?.Message ?? "User created successfully", result?.User);
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"CreateUserAsync failed. Status: {response.StatusCode}, Error: {errorContent}");

                    try
                    {
                        var errorResult = JsonSerializer.Deserialize<ErrorResult>(errorContent,
                            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                        return (false, errorResult?.Message ?? "Failed to create user", null);
                    }
                    catch
                    {
                        return (false, "Failed to create user", null);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error creating user: {ex.Message}");
                return (false, $"Error: {ex.Message}", null);
            }
        }

        // PUT: api/users/{id}
        public async Task<(bool Success, string Message, UserViewModel? User)> UpdateUserAsync(string id, UpdateUserRequest request)
        {
            try
            {
                Console.WriteLine($"Updating user: {id}");

                var response = await _httpClient.PutAsJsonAsync($"api/user/{id}", request);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<UpdateUserResult>();
                    return (true, result?.Message ?? "User updated successfully", result?.User);
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"UpdateUserAsync failed. Status: {response.StatusCode}, Error: {errorContent}");

                    try
                    {
                        var errorResult = JsonSerializer.Deserialize<ErrorResult>(errorContent,
                            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                        return (false, errorResult?.Message ?? "Failed to update user", null);
                    }
                    catch
                    {
                        return (false, "Failed to update user", null);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error updating user: {ex.Message}");
                return (false, $"Error: {ex.Message}", null);
            }
        }

        // DELETE: api/users/{id}
        public async Task<(bool Success, string Message)> DeleteUserAsync(string id)
        {
            try
            {
                Console.WriteLine($"Deleting user: {id}");

                var response = await _httpClient.DeleteAsync($"api/user/{id}");

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<DeleteUserResult>();
                    return (true, result?.Message ?? "User deleted successfully");
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"DeleteUserAsync failed. Status: {response.StatusCode}, Error: {errorContent}");

                    try
                    {
                        var errorResult = JsonSerializer.Deserialize<ErrorResult>(errorContent,
                            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                        return (false, errorResult?.Message ?? "Failed to delete user");
                    }
                    catch
                    {
                        return (false, "Failed to delete user");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error deleting user: {ex.Message}");
                return (false, $"Error: {ex.Message}");
            }
        }

        // =============================================================
        // SESSIONS
        // =============================================================

        // GET: api/session/user/{userId}   
        public async Task<List<Session>> GetSessionsByUserAsync(string userId)
        {
          
            try
            {
                Console.WriteLine($"Getting sessions for user: {userId}");

                var response = await _httpClient.GetAsync($"api/session/user/{userId}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Sessions response: {content}");

                    var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                    return JsonSerializer.Deserialize<List<Session>>(content, options) ?? new List<Session>();
                }

                Console.WriteLine($"GetSessionsByUserAsync failed. Status: {response.StatusCode}");
                return new List<Session>();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching sessions: {ex.Message}");
                return new List<Session>();
            }
        }

        // =============================================================
        // READINGS
        // =============================================================

        // GET: api/reading/session/{sessionId}  (two-parameter version just forwards)
        public async Task<List<Reading>> GetReadingsBySessionAsync(string userId, string sessionId)
        {
            try
            {
                Console.WriteLine($"Getting readings for user {userId}, session {sessionId}");

                var response = await _httpClient.GetAsync($"api/reading/session/{sessionId}");

                Console.WriteLine($"GetReadingsBySessionAsync (two params) Status: {response.StatusCode}");

                if (response.IsSuccessStatusCode)
                {
                    var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };

                    var content = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Readings for session {sessionId}: {content}");
                    return JsonSerializer.Deserialize<List<Reading>>(content, options) ?? new List<Reading>();
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Failed to get readings. Status: {response.StatusCode}, Error: {errorContent}");
                    Console.WriteLine("Falling back to generic readings endpoint...");
                    return await GetReadingsBySessionAsync(sessionId);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching readings: {ex.Message}");
                return new List<Reading>();
            }
        }

        // GET: api/reading/session/{sessionId}   
        public async Task<List<Reading>> GetReadingsBySessionAsync(string sessionId)
        {
            try
            {
                Console.WriteLine($"Getting readings for session: {sessionId}");

                var response = await _httpClient.GetAsync($"api/reading/session/{sessionId}");

                Console.WriteLine($"GetReadingsBySessionAsync (single param) Status: {response.StatusCode}");

                if (response.IsSuccessStatusCode)
                {
                    var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                    var content = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Readings for session {sessionId}: {content}");
                    return JsonSerializer.Deserialize<List<Reading>>(content, options) ?? new List<Reading>();
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Failed to get readings. Status: {response.StatusCode}, Error: {errorContent}");
                    return new List<Reading>();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching readings: {ex.Message}");
                return new List<Reading>();
            }
        }

        // GET: api/reading/{userId}/{sessionId}
        public async Task<Reading?> GetReadingByUserAndSessionAsync(string userId, string sessionId)
        {
            try
            {
                var response = await _httpClient.GetAsync($"api/reading/{userId}/{sessionId}");
                if (response.IsSuccessStatusCode)
                {
                    var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                    var content = await response.Content.ReadAsStringAsync();
                    return JsonSerializer.Deserialize<Reading>(content, options);
                }

                Console.WriteLine($"GetReadingByUserAndSessionAsync failed. Status: {response.StatusCode}");
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching reading by user+session: {ex.Message}");
                return null;
            }
        }

        // =============================================================
        // AUTH / LOGIN 
        // =============================================================

        // This is the method your Login.razor page calls:
        // public async Task<UserViewModel?> LoginAsync(LoginViewModel loginData)
        public async Task<UserViewModel?> LoginAsync(LoginViewModel loginData)
        {
            try
            {
                Console.WriteLine($"Attempting login for: {loginData.Email}");

                // This uses cookie-based auth for the dashboard
                var response = await _httpClient.PostAsJsonAsync("login?useCookies=true", loginData);

                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine($"Login successful for: {loginData.Email}");

                    // After login, cookies are set on the HTTP response and will be
                    // sent automatically on subsequent HttpClient calls.

                    // Method 1: Get from admin endpoint
                    var allUsers = await GetUsersAsync();
                    var currentUser = allUsers.FirstOrDefault(u =>
                        u.Email.Equals(loginData.Email, StringComparison.OrdinalIgnoreCase));

                    if (currentUser != null)
                    {
                        Console.WriteLine($"Found user in admin list. Role: {currentUser.Role}");
                        return currentUser;
                    }

                    // Method 2: fall back to manage/info if needed
                    Console.WriteLine("User not found in admin list, trying manage/info");
                    var userInfo = await GetCurrentUserInfoAsync();
                    if (userInfo != null)
                    {
                        Console.WriteLine($" Got user from manage/info. Role: {userInfo.Role}");
                        return userInfo;
                    }

                    Console.WriteLine("Could not retrieve user info after login");
                    return null;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Login failed. Status: {response.StatusCode}, Error: {errorContent}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error logging in: {ex.Message}");
                return null;
            }
        }

        // GET: /manage/info  (current user info after login)
        public async Task<UserViewModel?> GetCurrentUserInfoAsync()
        {
            try
            {
                var response = await _httpClient.GetAsync("manage/info");

                if (response.IsSuccessStatusCode)
                {
                    var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                    var content = await response.Content.ReadAsStringAsync();
                    var user = JsonSerializer.Deserialize<UserViewModel>(content, options);
                    return user;
                }

                Console.WriteLine($"GetCurrentUserInfoAsync failed. Status: {response.StatusCode}");
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching current user info: {ex.Message}");
                return null;
            }
        }

        // Check role helper 
        public async Task<string?> CheckUserRole(string email)
        {
            try
            {
                var users = await GetUsersAsync();
                var user = users.FirstOrDefault(u => u.Email == email);

                if (user != null)
                {
                    Console.WriteLine($"User {email} found. Role: {user.Role}");
                    return user.Role;
                }

                Console.WriteLine($"User {email} not found in users list");
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error checking role: {ex.Message}");
                return null;
            }
        }

        // Simple logout helper – clear cookies on client by redirecting
        public async Task LogoutAsync()
        {
            try
            {
                // Optional: tell the backend to clear identity cookies
                await _httpClient.PostAsync("logout", null);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Backend logout failed: {ex.Message}");
            }
        }
        public class CreateUserRequest
        {
            public string FullName { get; set; } = "";
            public string Email { get; set; } = "";
            public string Password { get; set; } = "";
            public string Role { get; set; } = "Member";
        }

        public class UpdateUserRequest
        {
            public string? FullName { get; set; }
            public string? Email { get; set; }
            public string? Password { get; set; }
            public string? Role { get; set; }
        }

        public class CreateUserResult
        {
            public string Message { get; set; } = "";
            public UserViewModel? User { get; set; }
        }

        public class UpdateUserResult
        {
            public string Message { get; set; } = "";
            public UserViewModel? User { get; set; }
        }

        public class DeleteUserResult
        {
            public string Message { get; set; } = "";
        }

        public class ErrorResult
        {
            public string Message { get; set; } = "";
            public List<string>? Errors { get; set; }
        }
    }
}