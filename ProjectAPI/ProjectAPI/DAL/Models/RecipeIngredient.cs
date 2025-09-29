using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ProjectAPI.DAL.Models;

[Index(nameof(RecipeId), nameof(IngredientId), IsUnique = true)]
public class RecipeIngredient
{
    [Key]
    public int RecipeIngredientId { get; set; }
    public int RecipeId { get; set; }
    public int IngredientId { get; set; }
    [Required]
    [Column(TypeName = "decimal(10, 2)")]
    public decimal QuantityValue { get; set; }
    [Required]
    [StringLength(50)]
    public string QuantityUnit { get; set; } = string.Empty;
    public string? Notes { get; set; }
    [ForeignKey("RecipeId")]
    public Recipe? Recipe { get; set; }
    [ForeignKey("IngredientId")]
    public Ingredient? Ingredient { get; set; }
}
