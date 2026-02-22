using System.Security.Claims;
using Microsoft.AspNetCore.Components.Authorization;
using qSmartWebDashboard.Data;
using qSmartWebDashboard.ViewModels;

namespace qSmartWebDashboard.Services


{
    public class AuthState : AuthenticationStateProvider


    {
        private readonly ApiDataService _apiDataService;
        private UserViewModel? _currentUser;
        private bool _isInitialized = false;

        public AuthState(ApiDataService apiDataService)
        {
            _apiDataService = apiDataService;
        }

        public bool IsAdmin => _currentUser?.Role == "Admin";
        public UserViewModel? CurrentUser => _currentUser;




        public async Task InitializeAsync()
        {
            if (!_isInitialized)
            {
                try
                {
                    // Try to get current user from backend
                    _currentUser = await _apiDataService.GetCurrentUserInfoAsync();
                    _isInitialized = true;

                    // Notify authentication state change
                    NotifyAuthenticationStateChanged(GetAuthenticationStateAsync());
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Auth initialization error: {ex.Message}");
                    _currentUser = null;
                    _isInitialized = true;
                }
            }
        }

        public override async Task<AuthenticationState> GetAuthenticationStateAsync()
        {
            if (!_isInitialized)
            {
                await InitializeAsync();
            }

            ClaimsIdentity identity;

            if (_currentUser != null && !string.IsNullOrEmpty(_currentUser.Id))
            {
                // Create claims for authenticated user
                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.NameIdentifier, _currentUser.Id),
                    new Claim(ClaimTypes.Name, _currentUser.FullName ?? _currentUser.Email),
                    new Claim(ClaimTypes.Email, _currentUser.Email),
                    new Claim(ClaimTypes.Role, _currentUser.Role ?? "Member")
                };

                identity = new ClaimsIdentity(claims, "backend");
            }
            else
            {
                identity = new ClaimsIdentity(); // Not authenticated
            }

            var user = new ClaimsPrincipal(identity);
            return new AuthenticationState(user);
        }

        public async Task SignInAsUser(UserViewModel user)
        {
            _currentUser = user;
            _isInitialized = true;

            NotifyAuthenticationStateChanged(GetAuthenticationStateAsync());
        }

        public async Task SignOut()
        {
            try
            {
                // Call backend logout
                await _apiDataService.LogoutAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Logout error: {ex.Message}");
            }

            _currentUser = null;
            _isInitialized = false;

            NotifyAuthenticationStateChanged(GetAuthenticationStateAsync());
        }
    }
}