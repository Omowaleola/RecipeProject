using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ProjectAPI.DAL.Models;

[PrimaryKey(nameof(RecipeId), nameof(TagId))]
public class RecipeTag
{
    public int RecipeId { get; set; }
    public int TagId { get; set; }
    [ForeignKey("RecipeId")]
    public Recipe? Recipe { get; set; }
    [ForeignKey("TagId")]
    public Tag? Tag { get; set; }
}