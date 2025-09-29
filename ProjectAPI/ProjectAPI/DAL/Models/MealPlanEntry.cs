using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ProjectAPI.DAL.Models;

public class MealPlanEntry
{
    [Key]
    public int MealPlanEntryId { get; set; }
    public int MealPlanId { get; set; }
    public int RecipeId { get; set; }
    [Required]
    [DataType(DataType.Date)]
    public DateOnly MealDate { get; set; }
    [Required]
    [StringLength(50)]
    public string MealType { get; set; } = string.Empty;
    [Required]
    public int ServingsToCook { get; set; }
    [ForeignKey("MealPlanId")]
    public MealPlan? MealPlan { get; set; }
    [ForeignKey("RecipeId")]
    public Recipe? Recipe { get; set; }
}
