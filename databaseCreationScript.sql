CREATE DATABASE IF NOT EXISTS recipe_db;

USE recipe_db;

CREATE TABLE IF NOT EXISTS asp_net_users (
    Id VARCHAR(450) NOT NULL,
    UserName VARCHAR(256) UNIQUE NOT NULL,
    NormalizedUserName VARCHAR(256) UNIQUE NULL,
    Email VARCHAR(256) UNIQUE NOT NULL,
    NormalizedEmail VARCHAR(256) UNIQUE NULL,
    EmailConfirmed TINYINT(1) NOT NULL DEFAULT 0,
    PasswordHash TEXT NULL,
    SecurityStamp TEXT NULL,
    ProfileImageUrl TEXT NULL,
    FavoriteCuisine VARCHAR(50) NULL,
    DateJoined DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT PK_AspNetUsers_Id PRIMARY KEY (Id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS asp_net_user_logins (
    LoginProvider VARCHAR(128) NOT NULL,
    ProviderKey VARCHAR(128) NOT NULL,
    UserId VARCHAR(450) NOT NULL,
    ProviderDisplayName TEXT NULL,
    CONSTRAINT PK_AspNetUserLogins_LoginProvider_ProviderKey PRIMARY KEY (LoginProvider, ProviderKey),
    CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES asp_net_users(Id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS recipes (
    RecipeId INT NOT NULL AUTO_INCREMENT,
    OwnerId VARCHAR(450) NOT NULL,
    Title VARCHAR(250) NOT NULL,
    Instructions TEXT NOT NULL,
    PrepTimeMinutes INT NULL,
    CookTimeMinutes INT NULL,
    Servings INT NULL,
    ImageUrl TEXT NULL,
    CONSTRAINT PK_Recipes_RecipeId PRIMARY KEY (RecipeId),
    CONSTRAINT FK_Recipes_AspNetUsers_OwnerId FOREIGN KEY (OwnerId) REFERENCES asp_net_users(Id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tags (
    TagId INT NOT NULL AUTO_INCREMENT,
    TagName VARCHAR(50) UNIQUE NOT NULL,
    CONSTRAINT PK_Tags_TagId PRIMARY KEY (TagId)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS recipe_tags (
    RecipeId INT NOT NULL,
    TagId INT NOT NULL,
    CONSTRAINT PK_RecipeTags_RecipeId_TagId PRIMARY KEY (RecipeId, TagId),
    CONSTRAINT FK_RecipeTags_Recipes_RecipeId FOREIGN KEY (RecipeId) REFERENCES recipes(RecipeId),
    CONSTRAINT FK_RecipeTags_Tags_TagId FOREIGN KEY (TagId) REFERENCES tags(TagId)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ingredients (
    IngredientId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(100) UNIQUE NOT NULL,
    AisleCategory VARCHAR(50) NULL,
    CONSTRAINT PK_Ingredients_IngredientId PRIMARY KEY (IngredientId)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS recipe_ingredients (
    RecipeIngredientId INT NOT NULL AUTO_INCREMENT,
    RecipeId INT NOT NULL,
    IngredientId INT NOT NULL,
    QuantityValue DECIMAL(10, 2) NOT NULL,
    QuantityUnit VARCHAR(50) NOT NULL,
    Notes TEXT NULL,
    CONSTRAINT PK_RecipeIngredients_RecipeIngredientId PRIMARY KEY(RecipeIngredientId),
    CONSTRAINT UK_RecipeIngredients_RecipeId_IngredientId UNIQUE (RecipeId, IngredientId),
    CONSTRAINT FK_RecipeIngredients_Recipes_RecipeId FOREIGN KEY (RecipeId) REFERENCES recipes(RecipeId),
    CONSTRAINT FK_RecipeIngredients_Ingredients_IngredientId FOREIGN KEY (IngredientId) REFERENCES ingredients(IngredientId)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS meal_plans (
    MealPlanId INT NOT NULL AUTO_INCREMENT,
    UserId VARCHAR(450) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT PK_MealPlans_MealPlanId PRIMARY KEY(MealPlanId),
    CONSTRAINT FK_MealPlans_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES asp_net_users(Id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS meal_plan_entries (
    MealPlanEntryId INT NOT NULL AUTO_INCREMENT,
    MealPlanId INT NOT NULL,
    RecipeId INT NOT NULL,
    MealDate DATE NOT NULL,
    MealType VARCHAR(50) NOT NULL,
    ServingsToCook INT NOT NULL,
    CONSTRAINT PK_MealPlanEntries_MealPlanEntryId PRIMARY KEY(MealPlanEntryId),
    CONSTRAINT FK_MealPlanEntries_MealPlans_MealPlanId FOREIGN KEY (MealPlanId) REFERENCES meal_plans(MealPlanId),
    CONSTRAINT FK_MealPlanEntries_Recipes_RecipeId FOREIGN KEY (RecipeId) REFERENCES recipes(RecipeId)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS shopping_list_items (
    ItemId INT NOT NULL AUTO_INCREMENT,
    MealPlanId INT NOT NULL,
    IngredientId INT NOT NULL,
    RequiredQuantity DECIMAL(10, 2) NOT NULL,
    UnitOfMeasure VARCHAR(50) NOT NULL,
    IsCheckedOff TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT PK_ShoppingListItems_ItemId PRIMARY KEY(ItemId),
    CONSTRAINT FK_ShoppingListItems_MealPlans_MealPlanId FOREIGN KEY (MealPlanId) REFERENCES meal_plans(MealPlanId),
    CONSTRAINT FK_ShoppingListItems_Ingredients_IngredientId FOREIGN KEY (IngredientId) REFERENCES ingredients(IngredientId)
) ENGINE=InnoDB;