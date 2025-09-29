using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjectAPI.DAL.Contexts;
using ProjectAPI.DAL.Models;

namespace ProjectAPI.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class MealPlansController : ControllerBase
{
    private readonly RecipeDbContext _context;

    public MealPlansController(RecipeDbContext context)
    {
        _context = context;
    }

    [HttpGet("active")]
    public async Task<ActionResult<MealPlan>> GetActiveMealPlan()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        var currentPlan = await _context.MealPlans
            .Where(mp => mp.UserId == userId && mp.IsActive)
            .Include(mp => mp.MealPlanEntries) // Assume a navigation property exists
            .OrderByDescending(mp => mp.StartDate)
            .FirstOrDefaultAsync();

        if (currentPlan == null) return NotFound("No active meal plan found.");
        
        return Ok(currentPlan);
    }
    
    [HttpPost]
    public async Task<ActionResult<MealPlan>> PostMealPlan([FromBody] MealPlan mealPlan)
    {
        mealPlan.UserId = User.FindFirstValue(ClaimTypes.NameIdentifier)!;
        
        if (mealPlan.IsActive)
        {
            await _context.MealPlans
                .Where(mp => mp.UserId == mealPlan.UserId && mp.IsActive)
                .ExecuteUpdateAsync(s => s.SetProperty(mp => mp.IsActive, false));
        }

        _context.MealPlans.Add(mealPlan);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetActiveMealPlan), new { id = mealPlan.MealPlanId }, mealPlan);
    }
    
    [HttpGet("{planId}/items")]
    public async Task<ActionResult<IEnumerable<MealPlanEntry>>> GetPlanItems(int planId)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!await _context.MealPlans.AnyAsync(mp => mp.MealPlanId == planId && mp.UserId == userId))
        {
            return Forbid();
        }

        var items = await _context.MealPlanEntries
            .Where(item => item.MealPlanId == planId)
            .Include(item => item.Recipe) 
            .ToListAsync();
            
        return Ok(items);
    }
    
    [HttpPost("{planId}/items")]
    public async Task<ActionResult<MealPlanEntry>> PostPlanItem(int planId, [FromBody] MealPlanEntry item)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        if (!await _context.MealPlans.AnyAsync(mp => mp.MealPlanId == planId && mp.UserId == userId))
        {
            return Forbid();
        }
        
        item.MealPlanId = planId;
        _context.MealPlanEntries.Add(item);
        await _context.SaveChangesAsync();

        return Created($"api/mealplans/{planId}/items/{item.MealPlanEntryId}", item);
    }
    
    [HttpDelete("items/{itemId}")]
    public async Task<IActionResult> DeletePlanItem(int itemId)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        var item = await _context.MealPlanEntries
            .Include(i => i.MealPlan)
            .FirstOrDefaultAsync(i => i.MealPlanEntryId == itemId);

        if (item == null) return NotFound();
        if (item.MealPlan.UserId != userId) return Forbid();

        _context.MealPlanEntries.Remove(item);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}