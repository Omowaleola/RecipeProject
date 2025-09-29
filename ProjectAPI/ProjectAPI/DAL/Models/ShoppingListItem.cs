using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ProjectAPI.DAL.Models;

public class ShoppingListItem
{
    [Key]
    public int ItemId { get; set; }
    public int MealPlanId { get; set; }
    public int IngredientId { get; set; }
    [Required]
    [Column(TypeName = "decimal(10, 2)")]
    public decimal RequiredQuantity { get; set; }
    [Required]
    [StringLength(50)]
    public string UnitOfMeasure { get; set; } = string.Empty;
    public bool IsCheckedOff { get; set; } = false;
    [ForeignKey("MealPlanId")]
    public MealPlan? MealPlan { get; set; }
    [ForeignKey("IngredientId")]
    public Ingredient? Ingredient { get; set; }
}