@echo off
echo Starting User Management API for testing...
echo.
echo Make sure to import the Postman collection from:
echo %~dp0PostmanCollection\UserManagementAPI.postman_collection.json
echo.
echo And the environment from:
echo %~dp0PostmanCollection\UserManagementAPI.environment.json
echo.
echo See the testing guide at:
echo %~dp0PostmanCollection\TestingGuide.md
echo.
echo Press Ctrl+C to stop the API when done testing.
echo.
dotnet run --urls="https://localhost:5001;http://localhost:5000"
