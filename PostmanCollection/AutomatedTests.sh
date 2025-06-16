#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base URL of the API
BASE_URL="https://localhost:5001"
AUTH_TOKEN="TechHive2025ApiKeySecret"

# Function to print section headers
print_header() {
    echo
    echo -e "${BLUE}===========================================================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===========================================================================================${NC}"
    echo
}

# Function to print test name
print_test() {
    echo
    echo -e "${YELLOW}⟹ Testing: $1${NC}"
    echo
}

# Function to send GET request
send_get() {
    local url="$1"
    local auth="$2"
    local expected_status="$3"
    
    print_test "$4"
    
    if [ "$auth" = true ]; then
        response=$(curl -s -o response.txt -w "%{http_code}" -k -H "Authorization: Bearer $AUTH_TOKEN" "$url")
    else
        response=$(curl -s -o response.txt -w "%{http_code}" -k "$url")
    fi
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✓ Status: $response (Expected: $expected_status)${NC}"
        echo -e "Response body:"
        cat response.txt | json_pp
        return 0
    else
        echo -e "${RED}✗ Status: $response (Expected: $expected_status)${NC}"
        echo -e "Response body:"
        cat response.txt
        return 1
    fi
}

# Function to send POST request
send_post() {
    local url="$1"
    local data="$2"
    local auth="$3"
    local expected_status="$4"
    
    print_test "$5"
    
    if [ "$auth" = true ]; then
        response=$(curl -s -o response.txt -w "%{http_code}" -k -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $AUTH_TOKEN" -d "$data" "$url")
    else
        response=$(curl -s -o response.txt -w "%{http_code}" -k -X POST -H "Content-Type: application/json" -d "$data" "$url")
    fi
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✓ Status: $response (Expected: $expected_status)${NC}"
        echo -e "Response body:"
        cat response.txt | json_pp
        return 0
    else
        echo -e "${RED}✗ Status: $response (Expected: $expected_status)${NC}"
        echo -e "Response body:"
        cat response.txt
        return 1
    fi
}

# Function to send PUT request
send_put() {
    local url="$1"
    local data="$2"
    local auth="$3"
    local expected_status="$4"
    
    print_test "$5"
    
    if [ "$auth" = true ]; then
        response=$(curl -s -o response.txt -w "%{http_code}" -k -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $AUTH_TOKEN" -d "$data" "$url")
    else
        response=$(curl -s -o response.txt -w "%{http_code}" -k -X PUT -H "Content-Type: application/json" -d "$data" "$url")
    fi
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✓ Status: $response (Expected: $expected_status)${NC}"
        echo -e "Response body:"
        cat response.txt | json_pp
        return 0
    else
        echo -e "${RED}✗ Status: $response (Expected: $expected_status)${NC}"
        echo -e "Response body:"
        cat response.txt
        return 1
    fi
}

# Function to send DELETE request
send_delete() {
    local url="$1"
    local auth="$2"
    local expected_status="$3"
    
    print_test "$4"
    
    if [ "$auth" = true ]; then
        response=$(curl -s -o response.txt -w "%{http_code}" -k -X DELETE -H "Authorization: Bearer $AUTH_TOKEN" "$url")
    else
        response=$(curl -s -o response.txt -w "%{http_code}" -k -X DELETE "$url")
    fi
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✓ Status: $response (Expected: $expected_status)${NC}"
        if [ -s response.txt ]; then
            echo -e "Response body:"
            cat response.txt | json_pp
        else
            echo -e "No response body (as expected for $expected_status)"
        fi
        return 0
    else
        echo -e "${RED}✗ Status: $response (Expected: $expected_status)${NC}"
        echo -e "Response body:"
        cat response.txt
        return 1
    fi
}

# Track test results
passed_tests=0
failed_tests=0

# Run tests and track results
run_test() {
    if [ $? -eq 0 ]; then
        passed_tests=$((passed_tests + 1))
    else
        failed_tests=$((failed_tests + 1))
    fi
}

# Main testing script
main() {
    print_header "USER MANAGEMENT API - AUTOMATED TEST SUITE"
    echo "Base URL: $BASE_URL"
    echo "Auth Token: $AUTH_TOKEN"
    
    # Create a variable to store newly created user ID
    new_user_id=""
    
    # Health Check (No Auth)
    print_header "1. BASIC CONNECTIVITY"
    
    send_get "$BASE_URL/api/health" false 200 "Health Check (No Auth)"
    run_test
    
    # Authentication Tests
    print_header "2. AUTHENTICATION TESTS"
    
    send_get "$BASE_URL/api/users" false 401 "Access Without Token (Error)"
    run_test
    
    send_get "$BASE_URL/api/users" true 200 "Access With Valid Token"
    run_test
    
    # Create an invalid token to test with
    INVALID_TOKEN="InvalidToken123"
    response=$(curl -s -o response.txt -w "%{http_code}" -k -H "Authorization: Bearer $INVALID_TOKEN" "$BASE_URL/api/users")
    print_test "Access With Invalid Token (Error)"
    if [ "$response" = "401" ]; then
        echo -e "${GREEN}✓ Status: $response (Expected: 401)${NC}"
        echo -e "Response body:"
        cat response.txt | json_pp
        passed_tests=$((passed_tests + 1))
    else
        echo -e "${RED}✗ Status: $response (Expected: 401)${NC}"
        echo -e "Response body:"
        cat response.txt
        failed_tests=$((failed_tests + 1))
    fi
    
    # User CRUD Tests
    print_header "3. USER MANAGEMENT - HAPPY PATH"
    
    # Get all users initially
    send_get "$BASE_URL/api/users" true 200 "Get All Users (initial)"
    run_test
    
    # Create a new user
    new_user='{"firstName":"Test","lastName":"User","email":"test.user@techhive.com","username":"testuser","department":"QA","phoneNumber":"555-123-4567"}'
    send_post "$BASE_URL/api/users" "$new_user" true 201 "Create User"
    run_test
    
    # Extract ID of created user
    if [ -s response.txt ]; then
        new_user_id=$(cat response.txt | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
        echo -e "Extracted User ID: $new_user_id"
    fi
    
    # Get the specific user
    if [ -n "$new_user_id" ]; then
        send_get "$BASE_URL/api/users/$new_user_id" true 200 "Get Specific User"
        run_test
    else
        echo -e "${RED}Could not extract user ID for subsequent tests${NC}"
        failed_tests=$((failed_tests + 1))
    fi
    
    # Update the user
    if [ -n "$new_user_id" ]; then
        updated_user='{"department":"Engineering","phoneNumber":"555-987-6543"}'
        send_put "$BASE_URL/api/users/$new_user_id" "$updated_user" true 200 "Update User"
        run_test
        
        # Verify the update
        send_get "$BASE_URL/api/users/$new_user_id" true 200 "Verify User Update"
        run_test
    fi
    
    # Delete the user
    if [ -n "$new_user_id" ]; then
        send_delete "$BASE_URL/api/users/$new_user_id" true 204 "Delete User"
        run_test
        
        # Verify the deletion
        send_get "$BASE_URL/api/users/$new_user_id" true 404 "Verify User Deletion"
        run_test
    fi
    
    print_header "4. USER MANAGEMENT - ERROR CASES"
    
    # Try to get non-existent user
    send_get "$BASE_URL/api/users/9999" true 404 "Get Non-Existent User"
    run_test
    
    # Try to create user with invalid data
    invalid_user='{"firstName":"","lastName":"Test","email":"notanemail","username":"te","department":"Testing","phoneNumber":"not-a-phone"}'
    send_post "$BASE_URL/api/users" "$invalid_user" true 400 "Create User With Invalid Data"
    run_test
    
    # Create another valid user to test duplicate checks
    new_user='{"firstName":"Another","lastName":"User","email":"another.user@techhive.com","username":"anotheruser","department":"Sales","phoneNumber":"555-222-3333"}'
    send_post "$BASE_URL/api/users" "$new_user" true 201 "Create Another User"
    run_test
    
    # Try to create user with duplicate email
    duplicate_email_user='{"firstName":"Duplicate","lastName":"Email","email":"another.user@techhive.com","username":"uniquename","department":"Marketing","phoneNumber":"555-444-5555"}'
    send_post "$BASE_URL/api/users" "$duplicate_email_user" true 400 "Create User With Duplicate Email"
    run_test
    
    # Try to create user with duplicate username
    duplicate_username_user='{"firstName":"Duplicate","lastName":"Username","email":"unique.email@techhive.com","username":"anotheruser","department":"Marketing","phoneNumber":"555-444-5555"}'
    send_post "$BASE_URL/api/users" "$duplicate_username_user" true 400 "Create User With Duplicate Username"
    run_test
    
    # Try to update non-existent user
    update_data='{"firstName":"Should","lastName":"Fail"}'
    send_put "$BASE_URL/api/users/9999" "$update_data" true 404 "Update Non-Existent User"
    run_test
    
    # Try to update user with invalid data
    if [ -n "$new_user_id" ]; then
        invalid_update='{"email":"not-an-email","phoneNumber":"not-a-phone"}'
        send_put "$BASE_URL/api/users/3" "$invalid_update" true 400 "Update User With Invalid Data"
        run_test
    fi
    
    # Try to delete non-existent user
    send_delete "$BASE_URL/api/users/9999" true 404 "Delete Non-Existent User"
    run_test
    
    # Print test summary
    print_header "TEST SUMMARY"
    echo -e "Total tests run: $((passed_tests + failed_tests))"
    echo -e "${GREEN}Passed: $passed_tests${NC}"
    echo -e "${RED}Failed: $failed_tests${NC}"
    
    if [ $failed_tests -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed.${NC}"
        exit 1
    fi
}

# Run the main function
main
