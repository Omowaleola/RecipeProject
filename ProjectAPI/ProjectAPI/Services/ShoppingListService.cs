using Microsoft.EntityFrameworkCore;
using ProjectAPI.DAL.Contexts;
using ProjectAPI.Models;

namespace ProjectAPI.Services;

public class ShoppingListService : IShoppingListService
{
    private readonly RecipeDbContext _context;

    public ShoppingListService(RecipeDbContext context)
    {
        _context = context;
    }

    public async Task<List<AggregatedIngredientDto>> AggregateIngredientsAsync(int mealPlanId)
    {
        var itemsInPlan = await _context.MealPlanEntries
            .Where(item => item.MealPlanId == mealPlanId)
            .Select(item => item.Recipe)
            .Include(r => r.RecipeIngredients)
            .ThenInclude(ri => ri.Ingredient) 
            .ToListAsync();
        
        if (!itemsInPlan.Any())
        {
            return new List<AggregatedIngredientDto>();
        }

        var aggregatedIngredients = itemsInPlan
            .SelectMany(r => r.RecipeIngredients)
            .Where(ri => ri.Ingredient != null) 
            .GroupBy(ri => new 
            { 
                Name = ri.Ingredient.Name,
                Unit = ri.QuantityUnit,
                Category = ri.Ingredient.AisleCategory
            }) 
            .Select(g => new AggregatedIngredientDto
            {
                Name = g.Key.Name,
                Unit = g.Key.Unit,
                Category = g.Key.Category,
                TotalQuantity = g.Sum(ri => ri.QuantityValue) 
            })
            .OrderBy(dto => dto.Category)
            .ThenBy(dto => dto.Name)
            .ToList();

        return aggregatedIngredients;
    }
}