using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ProjectAPI.DAL.Models;

public class Tag
{
    [Key]
    public int TagId { get; set; }
    [Required]
    [StringLength(50)]
    public string TagName { get; set; } = string.Empty;
    public ICollection<RecipeTag>? RecipeTags { get; set; }
}
