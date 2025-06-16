using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace UserManagementAPI.Middleware
{
    public class LoggingMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<LoggingMiddleware> _logger;

        public LoggingMiddleware(RequestDelegate next, ILogger<LoggingMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            // Log the request
            _logger.LogInformation(
                "Request: {Method} {Path} {QueryString} {ContentType}",
                context.Request.Method,
                context.Request.Path,
                context.Request.QueryString,
                context.Request.ContentType);

            // Enable buffering to read the response body
            context.Response.Body = new MemoryStream();
            
            // Store the original body stream
            var originalBodyStream = context.Response.Body;
            
            try
            {
                // Create a new memory stream to capture response
                using var responseBody = new MemoryStream();
                context.Response.Body = responseBody;

                // Call the next middleware
                await _next(context);

                // Log the response
                context.Response.Body.Position = 0;
                var responseBodyText = await new StreamReader(context.Response.Body).ReadToEndAsync();
                context.Response.Body.Position = 0;

                _logger.LogInformation(
                    "Response: {StatusCode} {StatusCodeText} {ContentType} {ContentLength}",
                    context.Response.StatusCode,
                    context.Response.StatusCode.ToString(),
                    context.Response.ContentType,
                    context.Response.ContentLength);

                // Copy the response to the original stream and return
                await responseBody.CopyToAsync(originalBodyStream);
            }
            finally
            {
                context.Response.Body = originalBodyStream;
            }
        }
    }

    // Extension method used to add the middleware to the HTTP request pipeline
    public static class LoggingMiddlewareExtensions
    {
        public static IApplicationBuilder UseLoggingMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<LoggingMiddleware>();
        }
    }
}
