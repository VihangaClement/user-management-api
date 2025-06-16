# User Management API Testing

This folder contains resources for testing the User Management API.

## Contents

1. **Postman Collection**:
   - `UserManagementAPI.postman_collection.json`: Complete collection of API requests for manual testing
   - `UserManagementAPI.environment.json`: Environment variables for the collection

2. **Automated Test Scripts**:
   - `AutomatedTests.sh`: Bash script for automated testing (Linux/Mac)
   - `AutomatedTests.ps1`: PowerShell script for automated testing (Windows)

3. **Documentation**:
   - `TestingGuide.md`: Detailed guide for using the Postman collection

## Getting Started with Postman

### Manual Testing with Postman

1. **Import the Collection and Environment**:
   - Open Postman
   - Click "Import" in the top left corner
   - Select both JSON files (`UserManagementAPI.postman_collection.json` and `UserManagementAPI.environment.json`)
   - Click "Import"

2. **Select the Environment**:
   - In the top-right corner, select "User Management API - Development" from the environment dropdown

3. **Start the API**:
   - Run the API using one of these methods:
     - Use the VS Code task: "Run User Management API"
     - Run the `StartApiForTesting.bat` or `StartApiForTesting.sh` script
     - Execute `dotnet run` in the API project directory

4. **Run the Tests**:
   - In the Postman sidebar, expand the "User Management API" collection
   - Run requests manually or use the Collection Runner to run all tests

For more detailed instructions, see the `TestingGuide.md` file.

## Automated Testing

### PowerShell (Windows)

```powershell
# Make sure the API is running first
cd C:\Path\To\UserManagementAPI
Start-Process -NoNewWindow powershell -ArgumentList "-Command","dotnet run"
Start-Sleep -Seconds 5  # Wait for API to start
cd PostmanCollection
.\AutomatedTests.ps1
```

### Bash (Linux/Mac)

```bash
# Make sure the API is running first
cd /path/to/UserManagementAPI
dotnet run &
sleep 5  # Wait for API to start
cd PostmanCollection
chmod +x AutomatedTests.sh
./AutomatedTests.sh
```

## Authentication

All authenticated requests use a Bearer token:

```
Authorization: Bearer TechHive2025ApiKeySecret
```

This token is already configured in the Postman environment and automated test scripts.

## API Endpoints Tested

- **GET /api/health**: Health check (no auth required)
- **GET /api/users**: Get all users
- **GET /api/users/{id}**: Get a specific user
- **POST /api/users**: Create a new user
- **PUT /api/users/{id}**: Update a user
- **DELETE /api/users/{id}**: Delete a user

## Test Coverage

The tests cover:

1. **Happy Path Scenarios**:
   - Creating, retrieving, updating, and deleting users

2. **Error Handling**:
   - Invalid authentication
   - Invalid input data
   - Non-existent resources
   - Duplicate email/username

3. **API Middleware**:
   - Authentication middleware (auth token validation)
   - Error handling middleware (consistent error responses)
   - Logging middleware (though logs are not validated in tests)
