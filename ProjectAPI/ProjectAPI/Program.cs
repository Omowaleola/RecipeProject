using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ProjectAPI.DAL.Contexts;
using ProjectAPI.DAL.Models;
using ProjectAPI.Services;

var builder = WebApplication.CreateBuilder(args);


var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
                       ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");


builder.Services.AddScoped<ITokenService, TokenService>();
builder.Services.AddScoped<IShoppingListService, ShoppingListService>();
builder.Services.AddDbContext<RecipeDbContext>(options =>
        options.UseMySQL(connectionString) 
);

builder.Services.AddDataProtection(); 
builder.Services
    .AddIdentityCore<ApplicationUser>(options =>
    {
        options.SignIn.RequireConfirmedEmail = true;
    })
    .AddEntityFrameworkStores<RecipeDbContext>()
    .AddSignInManager()
    .AddDefaultTokenProviders();


builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();