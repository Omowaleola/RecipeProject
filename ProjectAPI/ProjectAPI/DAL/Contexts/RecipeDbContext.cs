using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using ProjectAPI.DAL.Models;

namespace ProjectAPI.DAL.Contexts;

public partial class RecipeDbContext : IdentityUserContext<ApplicationUser>
{
    public RecipeDbContext(DbContextOptions<RecipeDbContext> options)
        : base(options)
    {
    }

    public DbSet<Recipe> Recipes { get; set; }
    public DbSet<Tag> Tags { get; set; }
    public DbSet<RecipeTag> RecipeTags { get; set; }
    public DbSet<Ingredient> Ingredients { get; set; }
    public DbSet<RecipeIngredient> RecipeIngredients { get; set; }
    public DbSet<MealPlan> MealPlans { get; set; }
    public DbSet<MealPlanEntry> MealPlanEntries { get; set; }
    public DbSet<ShoppingListItem> ShoppingListItems { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        
        base.OnModelCreating(modelBuilder);modelBuilder.Entity<ApplicationUser>().ToTable("aspnetusers");
        modelBuilder.Entity<IdentityUserLogin<string>>().ToTable("aspnetuserlogins");
        modelBuilder.Entity<RecipeTag>()
            .HasKey(rt => new { rt.RecipeId, rt.TagId });
        modelBuilder.Entity<Recipe>()
            .HasOne(r => r.Owner)
            .WithMany(u => u.Recipes)
            .HasForeignKey(r => r.OwnerId)
            .OnDelete(DeleteBehavior.Restrict);
        modelBuilder.Entity<RecipeIngredient>()
            .HasIndex(ri => new { ri.RecipeId, ri.IngredientId })
            .IsUnique();
    }
}
