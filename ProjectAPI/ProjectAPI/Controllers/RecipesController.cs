using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjectAPI.DAL.Contexts;
using ProjectAPI.DAL.Models;

namespace ProjectAPI.Controllers;

[Authorize] // Requires a valid JWT token for all methods
[Route("api/[controller]")]
[ApiController]
public class RecipesController : ControllerBase
{
    private readonly RecipeDbContext _context;

    public RecipesController(RecipeDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Recipe>>> GetUserRecipes()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        var recipes = await _context.Recipes
                                    .Where(r => r.OwnerId == userId)
                                    .ToListAsync();

        return Ok(recipes);
    }

    [HttpPost]
    public async Task<ActionResult<Recipe>> PostRecipe([FromBody] Recipe recipe)
    {
        recipe.OwnerId = User.FindFirstValue(ClaimTypes.NameIdentifier)!;

        _context.Recipes.Add(recipe);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetRecipe), new { id = recipe.RecipeId }, recipe);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Recipe>> GetRecipe(int id)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var recipe = await _context.Recipes
                                    .FirstOrDefaultAsync(r => r.RecipeId == id && r.OwnerId == userId);

        if (recipe == null)
        {
            return NotFound();
        }

        return Ok(recipe);
    }
    
    [HttpPut("{id}")]
    public async Task<IActionResult> PutRecipe(int id, [FromBody] Recipe recipe)
    {
        if (id != recipe.RecipeId)
        {
            return BadRequest();
        }
        
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var existingRecipe = await _context.Recipes
                                           .AsNoTracking()
                                           .FirstOrDefaultAsync(r => r.RecipeId == id);
        
        if (existingRecipe == null || existingRecipe.OwnerId != userId)
        {
            return Forbid(); 
        }

        recipe.OwnerId = userId; 
        
        _context.Entry(recipe).State = EntityState.Modified;
        await _context.SaveChangesAsync();

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteRecipe(int id)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var recipe = await _context.Recipes
                                    .FirstOrDefaultAsync(r => r.RecipeId == id && r.OwnerId == userId);

        if (recipe == null)
        {
            return NotFound();
        }

        _context.Recipes.Remove(recipe);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}