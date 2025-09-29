using Microsoft.AspNetCore.Identity;

namespace ProjectAPI.DAL.Models;

public class ApplicationUser : IdentityUser
{
    public string? ProfileImageUrl { get; set; }
    public string? FavoriteCuisine { get; set; }
    public DateTime DateJoined { get; set; } = DateTime.Now;
    public ICollection<Recipe>? Recipes { get; set; }
    public ICollection<MealPlan>? MealPlans { get; set; }
}