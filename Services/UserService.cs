using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UserManagementAPI.Data;
using UserManagementAPI.DTOs;
using UserManagementAPI.Models;

namespace UserManagementAPI.Services
{
    public interface IUserService
    {
        Task<IEnumerable<UserDto>> GetAllUsersAsync();
        Task<UserDto?> GetUserByIdAsync(int id);
        Task<UserDto> CreateUserAsync(CreateUserDto userDto);
        Task<UserDto?> UpdateUserAsync(int id, UpdateUserDto userDto);
        Task<bool> DeleteUserAsync(int id);
        Task<bool> UserExistsAsync(int id);
        Task<bool> IsEmailUniqueAsync(string email, int? userId = null);
        Task<bool> IsUsernameUniqueAsync(string username, int? userId = null);
    }

    public class UserService : IUserService
    {
        private readonly UserDbContext _context;

        public UserService(UserDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<UserDto>> GetAllUsersAsync()
        {
            var users = await _context.Users.ToListAsync();
            return users.Select(u => MapUserToDto(u));
        }

        public async Task<UserDto?> GetUserByIdAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            return user != null ? MapUserToDto(user) : null;
        }

        public async Task<UserDto> CreateUserAsync(CreateUserDto userDto)
        {
            var user = new User
            {
                FirstName = userDto.FirstName,
                LastName = userDto.LastName,
                Email = userDto.Email,
                Username = userDto.Username,
                Department = userDto.Department,
                PhoneNumber = userDto.PhoneNumber,
                CreatedAt = DateTime.UtcNow,
                IsActive = true
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return MapUserToDto(user);
        }

        public async Task<UserDto?> UpdateUserAsync(int id, UpdateUserDto userDto)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return null;

            // Only update properties that are provided
            if (userDto.FirstName != null)
                user.FirstName = userDto.FirstName;
            
            if (userDto.LastName != null)
                user.LastName = userDto.LastName;
            
            if (userDto.Email != null)
                user.Email = userDto.Email;
            
            if (userDto.Username != null)
                user.Username = userDto.Username;
            
            if (userDto.Department != null)
                user.Department = userDto.Department;
            
            if (userDto.PhoneNumber != null)
                user.PhoneNumber = userDto.PhoneNumber;
            
            if (userDto.IsActive.HasValue)
                user.IsActive = userDto.IsActive.Value;

            user.UpdatedAt = DateTime.UtcNow;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!await UserExistsAsync(id))
                    return null;
                throw;
            }

            return MapUserToDto(user);
        }

        public async Task<bool> DeleteUserAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return false;

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UserExistsAsync(int id)
        {
            return await _context.Users.AnyAsync(e => e.Id == id);
        }

        public async Task<bool> IsEmailUniqueAsync(string email, int? userId = null)
        {
            return !await _context.Users.AnyAsync(u => 
                u.Email.ToLower() == email.ToLower() && 
                (userId == null || u.Id != userId));
        }

        public async Task<bool> IsUsernameUniqueAsync(string username, int? userId = null)
        {
            return !await _context.Users.AnyAsync(u => 
                u.Username.ToLower() == username.ToLower() && 
                (userId == null || u.Id != userId));
        }

        private static UserDto MapUserToDto(User user)
        {
            return new UserDto
            {
                Id = user.Id,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Username = user.Username,
                Department = user.Department,
                PhoneNumber = user.PhoneNumber,
                CreatedAt = user.CreatedAt,
                UpdatedAt = user.UpdatedAt,
                IsActive = user.IsActive
            };
        }
    }
}
