using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;
using UserManagementAPI.DTOs;
using UserManagementAPI.Services;

namespace UserManagementAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly IUserService _userService;

        public UsersController(IUserService userService)
        {
            _userService = userService;
        }

        // GET: api/Users
        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _userService.GetAllUsersAsync();
            return Ok(users);
        }

        // GET: api/Users/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetUser(int id)
        {
            var user = await _userService.GetUserByIdAsync(id);

            if (user == null)
            {
                return NotFound($"User with ID {id} not found.");
            }

            return Ok(user);
        }

        // POST: api/Users
        [HttpPost]
        public async Task<IActionResult> CreateUser(CreateUserDto userDto)
        {
            // Check for uniqueness of email and username
            if (!await _userService.IsEmailUniqueAsync(userDto.Email))
            {
                ModelState.AddModelError("Email", "Email is already in use.");
                return BadRequest(ModelState);
            }

            if (!await _userService.IsUsernameUniqueAsync(userDto.Username))
            {
                ModelState.AddModelError("Username", "Username is already taken.");
                return BadRequest(ModelState);
            }

            var createdUser = await _userService.CreateUserAsync(userDto);
            return CreatedAtAction(nameof(GetUser), new { id = createdUser.Id }, createdUser);
        }

        // PUT: api/Users/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, UpdateUserDto userDto)
        {
            if (!await _userService.UserExistsAsync(id))
            {
                return NotFound($"User with ID {id} not found.");
            }

            // Check email uniqueness if it's being updated
            if (userDto.Email != null && !await _userService.IsEmailUniqueAsync(userDto.Email, id))
            {
                ModelState.AddModelError("Email", "Email is already in use.");
                return BadRequest(ModelState);
            }

            // Check username uniqueness if it's being updated
            if (userDto.Username != null && !await _userService.IsUsernameUniqueAsync(userDto.Username, id))
            {
                ModelState.AddModelError("Username", "Username is already taken.");
                return BadRequest(ModelState);
            }

            var updatedUser = await _userService.UpdateUserAsync(id, userDto);
            
            if (updatedUser == null)
            {
                return NotFound($"User with ID {id} not found.");
            }

            return Ok(updatedUser);
        }

        // DELETE: api/Users/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            if (!await _userService.UserExistsAsync(id))
            {
                return NotFound($"User with ID {id} not found.");
            }

            var result = await _userService.DeleteUserAsync(id);
            
            if (!result)
            {
                return NotFound($"User with ID {id} not found.");
            }

            return NoContent();
        }
    }
}
