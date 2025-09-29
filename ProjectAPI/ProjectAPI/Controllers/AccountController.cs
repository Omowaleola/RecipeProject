using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using ProjectAPI.DAL.Models;
using ProjectAPI.Models;
using ProjectAPI.Services;

namespace ProjectAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AccountController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _userManager;
    
    private readonly ITokenService _tokenService; 

    public AccountController(UserManager<ApplicationUser> userManager, ITokenService tokenService)
    {
        _userManager = userManager;
        _tokenService = tokenService;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterDto model)
    {
        var user = new ApplicationUser
        {
            UserName = model.Email,
            Email = model.Email,
            FavoriteCuisine = model.FavoriteCuisine,
            DateJoined = DateTime.UtcNow
        };

        var result = await _userManager.CreateAsync(user, model.Password);

        if (result.Succeeded)
        {
            return Ok(new { Message = "Registration successful" });
        }

        return BadRequest(result.Errors);
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginDto model)
    {
        var user = await _userManager.FindByEmailAsync(model.Email);

        if (user == null || !await _userManager.CheckPasswordAsync(user, model.Password))
        {
            return Unauthorized(new { Message = "Invalid credentials" });
        }
        
        var token = _tokenService.CreateToken(user);

        return Ok(new { Token = token });
    }
    
    [HttpGet("userinfo")]
    [Authorize]
    public IActionResult GetUserInfo()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        return Ok(new 
        {
            UserId = userId,
            Email = User.FindFirstValue(ClaimTypes.Email),
            Cuisine = User.FindFirst("FavoriteCuisine")?.Value 
        });
    }
}