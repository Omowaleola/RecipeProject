using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ProjectAPI.DAL.Models;

public class Ingredient
{
    [Key]
    public int IngredientId { get; set; }
    [Required]
    [StringLength(100)]
    public string Name { get; set; } = string.Empty;
    [StringLength(50)]
    public string? AisleCategory { get; set; }
    public ICollection<RecipeIngredient>? RecipeIngredients { get; set; }
    public ICollection<ShoppingListItem>? ShoppingListItems { get; set; }
}
