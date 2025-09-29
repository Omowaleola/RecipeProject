using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ProjectAPI.DAL.Models;

public class MealPlan
{
    [Key]
    public int MealPlanId { get; set; }
    [Required]
    public string UserId { get; set; } = string.Empty;
    [Required]
    [StringLength(100)]
    public string Name { get; set; } = string.Empty;
    [Required]
    [DataType(DataType.Date)]
    public DateOnly StartDate { get; set; }
    [Required]
    [DataType(DataType.Date)]
    public DateOnly EndDate { get; set; }
    public bool IsActive { get; set; } = true;
    [ForeignKey("UserId")]
    public ApplicationUser? User { get; set; }
    public ICollection<MealPlanEntry>? MealPlanEntries { get; set; }
    public ICollection<ShoppingListItem>? ShoppingListItems { get; set; }
}