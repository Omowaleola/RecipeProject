using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ProjectAPI.DAL.Models;

public class Recipe
{
    [Key]
    public int RecipeId { get; set; }
    [Required]
    public string OwnerId { get; set; } = string.Empty;
    [Required]
    [StringLength(250)]
    public string Title { get; set; } = string.Empty;
    [Required]
    public string Instructions { get; set; } = string.Empty;
    public int? PrepTimeMinutes { get; set; }
    public int? CookTimeMinutes { get; set; }
    public int? Servings { get; set; }
    public string? ImageUrl { get; set; }
    [ForeignKey("OwnerId")]
    public ApplicationUser? Owner { get; set; }
    public ICollection<RecipeTag>? RecipeTags { get; set; }
    public ICollection<RecipeIngredient>? RecipeIngredients { get; set; }
}
