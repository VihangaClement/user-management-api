using Microsoft.EntityFrameworkCore;
using UserManagementAPI.Data;
using UserManagementAPI.Middleware;
using UserManagementAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

// Add DbContext using in-memory database for demonstration
builder.Services.AddDbContext<UserDbContext>(options =>
    options.UseInMemoryDatabase("UserManagementDb"));

// Register services
builder.Services.AddScoped<IUserService, UserService>();

// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

// Add health checks
builder.Services.AddHealthChecks();

// Add CORS policy
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(builder =>
    {
        builder.AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

// Configure logging
builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Logging.AddDebug();

var app = builder.Build();

// Configure the HTTP request pipeline.
// Order is important!

// 1. Error handling middleware (first to catch all exceptions)
app.UseErrorHandlingMiddleware();

// 2. Authentication middleware
app.UseCustomAuthenticationMiddleware();

// 3. CORS policy
app.UseCors();

// 4. HTTPS Redirection
app.UseHttpsRedirection();

// 5. Routing & authorization
app.UseRouting();
app.UseAuthorization();

// 6. Logging middleware
app.UseLoggingMiddleware();

// 7. Map controllers and endpoints
app.MapControllers();

// 8. Health check endpoint (doesn't require authentication)
app.MapHealthChecks("/api/health");

// OpenAPI/Swagger in development
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

// Initialize and seed the database
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var dbContext = services.GetRequiredService<UserDbContext>();
    dbContext.Database.EnsureCreated();
}

app.Run();
