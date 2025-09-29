using ProjectAPI.Models;

namespace ProjectAPI.Services;

public interface IShoppingListService
{
    Task<List<AggregatedIngredientDto>> AggregateIngredientsAsync(int mealPlanId);
}