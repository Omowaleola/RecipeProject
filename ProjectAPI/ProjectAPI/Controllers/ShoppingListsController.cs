using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjectAPI.DAL.Contexts;
using ProjectAPI.DAL.Models;
using ProjectAPI.Services;

namespace ProjectAPI.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class ShoppingListsController : ControllerBase
{
    private readonly RecipeDbContext _context;
    private readonly IShoppingListService _shoppingListService; 

    public ShoppingListsController(RecipeDbContext context, IShoppingListService shoppingListService)
    {
        _context = context;
        _shoppingListService = shoppingListService;
    }
    
    [HttpPost("generate")]
    public async Task<IActionResult> GenerateAndGetList([FromBody] int mealPlanId)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!await _context.MealPlans.AnyAsync(mp => mp.MealPlanId == mealPlanId && mp.UserId == userId))
        {
            return NotFound("Meal Plan not found or unauthorized.");
        }
        
        
        var aggregatedList = await _shoppingListService.AggregateIngredientsAsync(mealPlanId);

        if (!aggregatedList.Any())
        {
            return NotFound("No recipes found in the plan to generate a list.");
        }

        return Ok(aggregatedList);
    }

    [HttpGet("manual")]
    public async Task<IActionResult> GetManualList()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        var list = await _context.ShoppingListItems 
            .Include(x=> x.MealPlan)// Assuming this DbSet exists
            .Where(item => item.MealPlan != null && item.MealPlan.UserId == userId)
            .OrderBy(item => item.IsCheckedOff)
            .ToListAsync();
            
        return Ok(list);
    }
    
    [HttpPost("manual")]
    public async Task<IActionResult> AddManualItem([FromBody] ShoppingListItem item)
    {
        _context.ShoppingListItems.Add(item);
        await _context.SaveChangesAsync();
        
        return CreatedAtAction(nameof(GetManualList), new { id = item.ItemId }, item);
    }
    
    [HttpPatch("manual/{itemId}/toggle")]
    public async Task<IActionResult> ToggleItemCompleted(int itemId)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var item = await _context.ShoppingListItems
                                 .FirstOrDefaultAsync(i => i.ItemId == itemId && i.MealPlan != null && i.MealPlan.UserId == userId);

        if (item == null) return NotFound();

        item.IsCheckedOff = !item.IsCheckedOff;
        await _context.SaveChangesAsync();

        return NoContent();
    }
}