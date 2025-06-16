# PowerShell script for automated testing of User Management API

# Base URL of the API
$baseUrl = "https://localhost:5001"
$authToken = "TechHive2025ApiKeySecret"

# Track test results
$passedTests = 0
$failedTests = 0

# Function to print section headers
function Write-Header {
    param([string]$title)
    Write-Host ""
    Write-Host "===========================================================================================" -ForegroundColor Blue
    Write-Host $title -ForegroundColor Blue
    Write-Host "===========================================================================================" -ForegroundColor Blue
    Write-Host ""
}

# Function to print test name
function Write-TestName {
    param([string]$name)
    Write-Host ""
    Write-Host "⟹ Testing: $name" -ForegroundColor Yellow
    Write-Host ""
}

# Function to send GET request
function Send-GetRequest {
    param(
        [string]$url,
        [bool]$auth,
        [int]$expectedStatus,
        [string]$testName
    )
    
    Write-TestName $testName
    
    try {
        $headers = @{}
        if ($auth) {
            $headers.Add("Authorization", "Bearer $authToken")
        }
        
        # Ignore SSL certificate errors for testing
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        
        $response = Invoke-WebRequest -Uri $url -Headers $headers -Method Get -SkipCertificateCheck -ErrorAction SilentlyContinue
        $statusCode = $response.StatusCode
        
        if ($statusCode -eq $expectedStatus) {
            Write-Host "✓ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Green
            Write-Host "Response body:"
            if ($response.Content) {
                $content = ConvertFrom-Json $response.Content -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            else {
                Write-Host "(Empty response body)"
            }
            return $true
        }
        else {
            Write-Host "✗ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Red
            Write-Host "Response body:"
            if ($response.Content) {
                $content = ConvertFrom-Json $response.Content -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $false
        }
    }
    catch {
        $statusCode = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { "Error" }
        
        if ($statusCode -eq $expectedStatus) {
            Write-Host "✓ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Green
            if ($_.ErrorDetails.Message) {
                Write-Host "Response body:"
                $content = ConvertFrom-Json $_.ErrorDetails.Message -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $true
        }
        else {
            Write-Host "✗ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Red
            Write-Host "Error message: $($_.Exception.Message)"
            if ($_.ErrorDetails.Message) {
                Write-Host "Response body:"
                $content = ConvertFrom-Json $_.ErrorDetails.Message -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $false
        }
    }
}

# Function to send POST request
function Send-PostRequest {
    param(
        [string]$url,
        [string]$body,
        [bool]$auth,
        [int]$expectedStatus,
        [string]$testName
    )
    
    Write-TestName $testName
    
    try {
        $headers = @{"Content-Type" = "application/json"}
        if ($auth) {
            $headers.Add("Authorization", "Bearer $authToken")
        }
        
        # Ignore SSL certificate errors for testing
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        
        $response = Invoke-WebRequest -Uri $url -Headers $headers -Method Post -Body $body -SkipCertificateCheck -ErrorAction SilentlyContinue
        $statusCode = $response.StatusCode
        
        if ($statusCode -eq $expectedStatus) {
            Write-Host "✓ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Green
            Write-Host "Response body:"
            if ($response.Content) {
                $content = ConvertFrom-Json $response.Content -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
                return $content
            }
            else {
                Write-Host "(Empty response body)"
            }
            return $true
        }
        else {
            Write-Host "✗ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Red
            Write-Host "Response body:"
            if ($response.Content) {
                $content = ConvertFrom-Json $response.Content -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $false
        }
    }
    catch {
        $statusCode = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { "Error" }
        
        if ($statusCode -eq $expectedStatus) {
            Write-Host "✓ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Green
            if ($_.ErrorDetails.Message) {
                Write-Host "Response body:"
                $content = ConvertFrom-Json $_.ErrorDetails.Message -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $true
        }
        else {
            Write-Host "✗ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Red
            Write-Host "Error message: $($_.Exception.Message)"
            if ($_.ErrorDetails.Message) {
                Write-Host "Response body:"
                $content = ConvertFrom-Json $_.ErrorDetails.Message -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $false
        }
    }
}

# Function to send PUT request
function Send-PutRequest {
    param(
        [string]$url,
        [string]$body,
        [bool]$auth,
        [int]$expectedStatus,
        [string]$testName
    )
    
    Write-TestName $testName
    
    try {
        $headers = @{"Content-Type" = "application/json"}
        if ($auth) {
            $headers.Add("Authorization", "Bearer $authToken")
        }
        
        # Ignore SSL certificate errors for testing
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        
        $response = Invoke-WebRequest -Uri $url -Headers $headers -Method Put -Body $body -SkipCertificateCheck -ErrorAction SilentlyContinue
        $statusCode = $response.StatusCode
        
        if ($statusCode -eq $expectedStatus) {
            Write-Host "✓ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Green
            Write-Host "Response body:"
            if ($response.Content) {
                $content = ConvertFrom-Json $response.Content -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            else {
                Write-Host "(Empty response body)"
            }
            return $true
        }
        else {
            Write-Host "✗ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Red
            Write-Host "Response body:"
            if ($response.Content) {
                $content = ConvertFrom-Json $response.Content -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $false
        }
    }
    catch {
        $statusCode = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { "Error" }
        
        if ($statusCode -eq $expectedStatus) {
            Write-Host "✓ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Green
            if ($_.ErrorDetails.Message) {
                Write-Host "Response body:"
                $content = ConvertFrom-Json $_.ErrorDetails.Message -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $true
        }
        else {
            Write-Host "✗ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Red
            Write-Host "Error message: $($_.Exception.Message)"
            if ($_.ErrorDetails.Message) {
                Write-Host "Response body:"
                $content = ConvertFrom-Json $_.ErrorDetails.Message -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $false
        }
    }
}

# Function to send DELETE request
function Send-DeleteRequest {
    param(
        [string]$url,
        [bool]$auth,
        [int]$expectedStatus,
        [string]$testName
    )
    
    Write-TestName $testName
    
    try {
        $headers = @{}
        if ($auth) {
            $headers.Add("Authorization", "Bearer $authToken")
        }
        
        # Ignore SSL certificate errors for testing
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        
        $response = Invoke-WebRequest -Uri $url -Headers $headers -Method Delete -SkipCertificateCheck -ErrorAction SilentlyContinue
        $statusCode = $response.StatusCode
        
        if ($statusCode -eq $expectedStatus) {
            Write-Host "✓ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Green
            Write-Host "Response body:"
            if ($response.Content) {
                $content = ConvertFrom-Json $response.Content -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            else {
                Write-Host "(Empty response body, as expected for $expectedStatus)"
            }
            return $true
        }
        else {
            Write-Host "✗ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Red
            Write-Host "Response body:"
            if ($response.Content) {
                $content = ConvertFrom-Json $response.Content -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $false
        }
    }
    catch {
        $statusCode = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { "Error" }
        
        if ($statusCode -eq $expectedStatus) {
            Write-Host "✓ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Green
            if ($_.ErrorDetails.Message) {
                Write-Host "Response body:"
                $content = ConvertFrom-Json $_.ErrorDetails.Message -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $true
        }
        else {
            Write-Host "✗ Status: $statusCode (Expected: $expectedStatus)" -ForegroundColor Red
            Write-Host "Error message: $($_.Exception.Message)"
            if ($_.ErrorDetails.Message) {
                Write-Host "Response body:"
                $content = ConvertFrom-Json $_.ErrorDetails.Message -ErrorAction SilentlyContinue
                $content | ConvertTo-Json -Depth 4
            }
            return $false
        }
    }
}

# Function to track test results
function Record-TestResult {
    param(
        [bool]$result
    )
    
    if ($result -eq $true) {
        $script:passedTests++
    }
    else {
        $script:failedTests++
    }
}

# Main testing script
function Run-TestSuite {
    Write-Header "USER MANAGEMENT API - AUTOMATED TEST SUITE"
    Write-Host "Base URL: $baseUrl"
    Write-Host "Auth Token: $authToken"
    
    # Health Check (No Auth)
    Write-Header "1. BASIC CONNECTIVITY"
    
    $result = Send-GetRequest "$baseUrl/api/health" $false 200 "Health Check (No Auth)"
    Record-TestResult $result
    
    # Authentication Tests
    Write-Header "2. AUTHENTICATION TESTS"
    
    $result = Send-GetRequest "$baseUrl/api/users" $false 401 "Access Without Token (Error)"
    Record-TestResult $result
    
    $result = Send-GetRequest "$baseUrl/api/users" $true 200 "Access With Valid Token"
    Record-TestResult $result
    
    # Create an invalid token to test with
    $invalidToken = $authToken
    $originalToken = $authToken
    $authToken = "InvalidToken123"
    
    $result = Send-GetRequest "$baseUrl/api/users" $true 401 "Access With Invalid Token (Error)"
    Record-TestResult $result
    
    # Restore the original token
    $authToken = $originalToken
    
    # User CRUD Tests
    Write-Header "3. USER MANAGEMENT - HAPPY PATH"
    
    # Get all users initially
    $result = Send-GetRequest "$baseUrl/api/users" $true 200 "Get All Users (initial)"
    Record-TestResult $result
    
    # Create a new user
    $newUser = @{
        firstName = "Test"
        lastName = "User"
        email = "test.user@techhive.com"
        username = "testuser"
        department = "QA"
        phoneNumber = "555-123-4567"
    } | ConvertTo-Json
    
    $response = Send-PostRequest "$baseUrl/api/users" $newUser $true 201 "Create User"
    $success = $response -ne $false
    Record-TestResult $success
    
    # Extract ID of created user
    $newUserId = $null
    if ($success -and $response -is [PSCustomObject]) {
        $newUserId = $response.id
        Write-Host "Extracted User ID: $newUserId"
    }
    
    # Get the specific user
    if ($newUserId) {
        $result = Send-GetRequest "$baseUrl/api/users/$newUserId" $true 200 "Get Specific User"
        Record-TestResult $result
    }
    else {
        Write-Host "Could not extract user ID for subsequent tests" -ForegroundColor Red
        $script:failedTests++
    }
    
    # Update the user
    if ($newUserId) {
        $updatedUser = @{
            department = "Engineering"
            phoneNumber = "555-987-6543"
        } | ConvertTo-Json
        
        $result = Send-PutRequest "$baseUrl/api/users/$newUserId" $updatedUser $true 200 "Update User"
        Record-TestResult $result
        
        # Verify the update
        $result = Send-GetRequest "$baseUrl/api/users/$newUserId" $true 200 "Verify User Update"
        Record-TestResult $result
    }
    
    # Delete the user
    if ($newUserId) {
        $result = Send-DeleteRequest "$baseUrl/api/users/$newUserId" $true 204 "Delete User"
        Record-TestResult $result
        
        # Verify the deletion
        $result = Send-GetRequest "$baseUrl/api/users/$newUserId" $true 404 "Verify User Deletion"
        Record-TestResult $result
    }
    
    Write-Header "4. USER MANAGEMENT - ERROR CASES"
    
    # Try to get non-existent user
    $result = Send-GetRequest "$baseUrl/api/users/9999" $true 404 "Get Non-Existent User"
    Record-TestResult $result
    
    # Try to create user with invalid data
    $invalidUser = @{
        firstName = ""
        lastName = "Test"
        email = "notanemail"
        username = "te"
        department = "Testing"
        phoneNumber = "not-a-phone"
    } | ConvertTo-Json
    
    $result = Send-PostRequest "$baseUrl/api/users" $invalidUser $true 400 "Create User With Invalid Data"
    Record-TestResult $result
    
    # Create another valid user to test duplicate checks
    $anotherUser = @{
        firstName = "Another"
        lastName = "User"
        email = "another.user@techhive.com"
        username = "anotheruser"
        department = "Sales"
        phoneNumber = "555-222-3333"
    } | ConvertTo-Json
    
    $response = Send-PostRequest "$baseUrl/api/users" $anotherUser $true 201 "Create Another User"
    $success = $response -ne $false
    Record-TestResult $success
    
    $anotherUserId = $null
    if ($success -and $response -is [PSCustomObject]) {
        $anotherUserId = $response.id
    }
    
    # Try to create user with duplicate email
    $duplicateEmailUser = @{
        firstName = "Duplicate"
        lastName = "Email"
        email = "another.user@techhive.com"
        username = "uniquename"
        department = "Marketing"
        phoneNumber = "555-444-5555"
    } | ConvertTo-Json
    
    $result = Send-PostRequest "$baseUrl/api/users" $duplicateEmailUser $true 400 "Create User With Duplicate Email"
    Record-TestResult $result
    
    # Try to create user with duplicate username
    $duplicateUsernameUser = @{
        firstName = "Duplicate"
        lastName = "Username"
        email = "unique.email@techhive.com"
        username = "anotheruser"
        department = "Marketing"
        phoneNumber = "555-444-5555"
    } | ConvertTo-Json
    
    $result = Send-PostRequest "$baseUrl/api/users" $duplicateUsernameUser $true 400 "Create User With Duplicate Username"
    Record-TestResult $result
    
    # Try to update non-existent user
    $updateData = @{
        firstName = "Should"
        lastName = "Fail"
    } | ConvertTo-Json
    
    $result = Send-PutRequest "$baseUrl/api/users/9999" $updateData $true 404 "Update Non-Existent User"
    Record-TestResult $result
    
    # Try to update user with invalid data
    if ($anotherUserId) {
        $invalidUpdate = @{
            email = "not-an-email"
            phoneNumber = "not-a-phone"
        } | ConvertTo-Json
        
        $result = Send-PutRequest "$baseUrl/api/users/$anotherUserId" $invalidUpdate $true 400 "Update User With Invalid Data"
        Record-TestResult $result
    }
    
    # Try to delete non-existent user
    $result = Send-DeleteRequest "$baseUrl/api/users/9999" $true 404 "Delete Non-Existent User"
    Record-TestResult $result
    
    # Clean up - delete the other test user if it was created
    if ($anotherUserId) {
        $result = Send-DeleteRequest "$baseUrl/api/users/$anotherUserId" $true 204 "Clean Up - Delete Second Test User"
        Record-TestResult $result
    }
    
    # Print test summary
    Write-Header "TEST SUMMARY"
    Write-Host "Total tests run: $($passedTests + $failedTests)"
    Write-Host "Passed: $passedTests" -ForegroundColor Green
    Write-Host "Failed: $failedTests" -ForegroundColor Red
    
    if ($failedTests -eq 0) {
        Write-Host "All tests passed!" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "Some tests failed." -ForegroundColor Red
        return $false
    }
}

# Run the test suite
Run-TestSuite
