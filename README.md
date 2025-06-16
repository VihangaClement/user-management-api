# User Management API

A RESTful API for managing user data with complete CRUD operations built with ASP.NET Core.

## Features

- Complete CRUD operations (GET, POST, PUT, DELETE)
- Validation for user data (email uniqueness, username uniqueness)
- Custom middleware implementation:
  - Authentication middleware
  - Error handling middleware
  - Logging middleware
- Entity Framework Core for data persistence

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /api/users | Get all users |
| GET    | /api/users/{id} | Get a specific user by ID |
| POST   | /api/users | Create a new user |
| PUT    | /api/users/{id} | Update an existing user |
| DELETE | /api/users/{id} | Delete a user |

## Technologies Used

- ASP.NET Core
- Entity Framework Core
- C#
- RESTful API principles

## Setup Instructions

1. Clone the repository
2. Navigate to the UserManagementAPI directory
3. Run `dotnet restore` to install dependencies
4. Run `dotnet run` to start the API server
5. Access the API at `https://localhost:5001/api/users`

## Project Structure

- Controllers: Contains API endpoint controllers
- Models: Data models and DTOs
- Services: Business logic implementation
- Middleware: Custom middleware components
- Data: Entity Framework context and configurations
