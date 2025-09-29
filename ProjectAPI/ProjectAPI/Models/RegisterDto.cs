﻿namespace ProjectAPI.Models;

using System.ComponentModel.DataAnnotations;

public class RegisterDto
{
    [Required, EmailAddress]
    public string Email { get; set; } = string.Empty;

    [Required, DataType(DataType.Password)]
    public string Password { get; set; } = string.Empty;

    public string? FavoriteCuisine { get; set; }
}