# User Management API - Postman Testing Guide

This guide will walk you through testing the User Management API using the provided Postman collection.

## Getting Started

1. Install [Postman](https://www.postman.com/downloads/) if you haven't already.
2. Import the collection and environment files:
   - Open Postman
   - Click "Import" in the top left corner
   - Select the files:
     - `UserManagementAPI.postman_collection.json`
     - `UserManagementAPI.environment.json`
   - Click "Import" to add them to your workspace

3. Select the "User Management API - Development" environment from the dropdown in the top right corner.

4. Ensure your API is running (using `dotnet watch run` or through the VS Code task)

## Available Tests

The collection is organized into three folders:

### Authentication

- **Health Check (No Auth)**: Verify the API is running without needing authentication.

### Users

- **Get All Users**: Retrieve all users (requires authentication).
- **Get User by ID**: Get details of a specific user (requires authentication).
- **Get Non-Existent User (Error)**: Test error handling for non-existent users.
- **Create User**: Add a new user to the system (requires authentication).
- **Create User - Invalid Data (Error)**: Test validation for incorrect user data.
- **Create User - Duplicate Email (Error)**: Test uniqueness validation for emails.
- **Create User - Duplicate Username (Error)**: Test uniqueness validation for usernames.
- **Update User**: Modify an existing user's details (requires authentication).
- **Update User - Invalid Data (Error)**: Test validation on user updates.
- **Update Non-existent User (Error)**: Test error handling for updating non-existent users.
- **Delete User**: Remove a user from the system (requires authentication).
- **Delete Non-existent User (Error)**: Test error handling for deleting non-existent users.

### Authentication Errors

- **Access Without Token (Error)**: Test accessing protected endpoints without authentication.
- **Access With Invalid Token (Error)**: Test accessing protected endpoints with an invalid token.

## Testing Process

### Basic Flow Testing (Happy Path)

1. Start with the **Health Check** to ensure the API is running.
2. Run **Get All Users** to see the initial seeded users.
3. Use **Create User** to add a new user.
4. Use **Get All Users** again to verify the user was added.
5. Use **Get User by ID** with the ID of the newly created user to fetch their details.
6. Use **Update User** to modify the user's information.
7. Use **Get User by ID** again to verify the changes.
8. Finally, use **Delete User** to remove the user.
9. Use **Get All Users** one more time to verify the user was removed.

### Error Testing

After testing the happy path, test the error cases:

1. Try to **Get/Update/Delete Non-Existent User** to test 404 handling.
2. Try to **Create User with Invalid Data** to test validation.
3. Try to create users with duplicate emails and usernames to test uniqueness constraints.
4. Try to **Access Without Token** and **Access With Invalid Token** to test authentication.

## Environment Variables

The collection uses two environment variables:

- **baseUrl**: The base URL of your API (default: `https://localhost:5001`)
- **authToken**: The authentication token (default: `TechHive2025ApiKeySecret`)

You can adjust these in the environment settings if needed.

## Port Configuration

If your API is running on a different port than 5001, update the `baseUrl` variable in the environment settings:

1. Click the "Environment quick look" button (eye icon) in the top right.
2. Edit the `baseUrl` value to match your API's URL (e.g., `https://localhost:7235`).
3. Click outside the edit field to save.

## Authentication

The API uses bearer token authentication. The token is automatically included in all requests that need authentication. The token is `TechHive2025ApiKeySecret` as defined in the AuthenticationMiddleware.

## Troubleshooting

- If you get connection errors, make sure the API is running.
- If `baseUrl` doesn't match your API's actual URL, update it in the environment settings.
- If you get 401 Unauthorized errors, check that the `authToken` is correct.
- The Health Check endpoint doesn't require authentication, so it's a good first test to verify connectivity.
