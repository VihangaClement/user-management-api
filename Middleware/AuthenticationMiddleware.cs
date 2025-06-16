using System;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace UserManagementAPI.Middleware
{
    public class AuthenticationMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<AuthenticationMiddleware> _logger;
        private const string AuthHeaderName = "Authorization";
        private const string BearerPrefix = "Bearer ";

        // In a real application, this would be a proper token validation and JWT service
        private const string ValidApiKey = "TechHive2025ApiKeySecret"; // This is just for demo purposes

        public AuthenticationMiddleware(RequestDelegate next, ILogger<AuthenticationMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            // Check if the path should be excluded from authentication
            if (IsPublicEndpoint(context.Request.Path))
            {
                await _next(context);
                return;
            }

            var authHeader = context.Request.Headers[AuthHeaderName].ToString();

            if (string.IsNullOrEmpty(authHeader) || !authHeader.StartsWith(BearerPrefix, StringComparison.OrdinalIgnoreCase))
            {
                _logger.LogWarning("Authentication failed: No Authorization header or invalid format");
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await context.Response.WriteAsJsonAsync(new { error = "Authentication required. Please provide a valid Bearer token." });
                return;
            }

            var token = authHeader.Substring(BearerPrefix.Length);

            if (!ValidateToken(token))
            {
                _logger.LogWarning("Authentication failed: Invalid token");
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await context.Response.WriteAsJsonAsync(new { error = "Invalid token. Authentication failed." });
                return;
            }

            // Token is valid, continue to the next middleware
            await _next(context);
        }

        private bool ValidateToken(string token)
        {
            // In a real application, this would be JWT validation or other token verification
            // For this example, we just check if it's equal to our hardcoded API key
            return token == ValidApiKey;
        }

        private bool IsPublicEndpoint(PathString path)
        {
            // Define paths that don't require authentication
            // In a real application, this could be more sophisticated or configurable
            return path.StartsWithSegments("/api/health") || 
                   path.StartsWithSegments("/swagger");
        }
    }

    // Extension method used to add the middleware to the HTTP request pipeline
    public static class AuthenticationMiddlewareExtensions
    {
        public static IApplicationBuilder UseCustomAuthenticationMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<AuthenticationMiddleware>();
        }
    }
}
