IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'AspNetUsers')
BEGIN

CREATE TABLE AspNetUsers (
    Id NVARCHAR(450),
    UserName NVARCHAR(256) UNIQUE NOT NULL,
    NormalizedUserName NVARCHAR(256) UNIQUE NULL,
    Email NVARCHAR(256) UNIQUE NOT NULL,
    NormalizedEmail NVARCHAR(256) UNIQUE NULL,
    EmailConfirmed BIT NOT NULL DEFAULT 0,
    PasswordHash NVARCHAR(MAX) NULL,
    SecurityStamp NVARCHAR(MAX) NULL,
    ProfileImageUrl NVARCHAR(MAX) NULL,
    FavoriteCuisine NVARCHAR(50) NULL,
    DateJoined DATETIME2 NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_AspNetUsers_Id PRIMARY KEY  (Id)
);

END
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'AspNetUserLogins')
BEGIN
CREATE TABLE AspNetUserLogins (
    LoginProvider NVARCHAR(128) NOT NULL,
    ProviderKey NVARCHAR(128) NOT NULL,
    UserId NVARCHAR(450) NOT NULL,
    ProviderDisplayName NVARCHAR(MAX) NULL,
    CONSTRAINT PK_AspNetUserLogins_LoginProvider_ProviderKey PRIMARY KEY (LoginProvider, ProviderKey),
    CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id)
);

END
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'Recipes')
BEGIN
CREATE TABLE Recipes (
    RecipeId INT IDENTITY(1,1),
    OwnerId NVARCHAR(450) NOT NULL,
    Title NVARCHAR(250) NOT NULL,
    Instructions NVARCHAR(MAX) NOT NULL, 
    PrepTimeMinutes INT NULL,
    CookTimeMinutes INT NULL,
    Servings INT NULL,
    ImageUrl NVARCHAR(MAX) NULL,   
	CONSTRAINT PK_Recipes_RecipeId PRIMARY KEY (RecipeId),
    CONSTRAINT FK_Recipes_AspNetUsers_OwnerId FOREIGN KEY (OwnerId) REFERENCES AspNetUsers(Id)
);

END
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'Tags')
BEGIN
CREATE TABLE Tags (
    TagId INT IDENTITY(1,1) ,
    TagName NVARCHAR(50) UNIQUE NOT NULL,
	CONSTRAINT PK_Tags_TagId PRIMARY KEY (TagId)
);

END
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'RecipeTags')
BEGIN
CREATE TABLE RecipeTags (
    RecipeId INT NOT NULL,
    TagId INT NOT NULL,
    CONSTRAINT PK_RecipeTags_RecipeId_TagId PRIMARY KEY (RecipeId, TagId),
    CONSTRAINT FK_RecipeTags_Recipes_RecipeId FOREIGN KEY (RecipeId) REFERENCES Recipes(RecipeId),
    CONSTRAINT FK_RecipeTags_Tags_TagId FOREIGN KEY (TagId) REFERENCES Tags(TagId)
);

END
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'Ingredients')
BEGIN
CREATE TABLE Ingredients (
    IngredientId INT IDENTITY(1,1),
    Name NVARCHAR(100) UNIQUE NOT NULL, 
    AisleCategory NVARCHAR(50) NULL,
	CONSTRAINT PK_Ingredients_IngredientId PRIMARY KEY (IngredientId)
);

END
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'RecipeIngredients')
BEGIN
CREATE TABLE RecipeIngredients (
    RecipeIngredientId INT IDENTITY(1,1),
    RecipeId INT NOT NULL,
    IngredientId INT NOT NULL,
    QuantityValue DECIMAL(10, 2) NOT NULL,
    QuantityUnit NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(MAX) NULL,  
	CONSTRAINT PK_RecipeIngredients_RecipeIngredientId PRIMARY KEY(RecipeIngredientId), 
    CONSTRAINT UK_RecipeIngredients_RecipeId_IngredientId UNIQUE (RecipeId, IngredientId),
    CONSTRAINT FK_RecipeIngredients_Recipes_RecipeId FOREIGN KEY (RecipeId) REFERENCES Recipes(RecipeId),
    CONSTRAINT FK_RecipeIngredients_Ingredients_IngredientId FOREIGN KEY (IngredientId) REFERENCES Ingredients(IngredientId)
);

END
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'MealPlans')
BEGIN
CREATE TABLE MealPlans (
    MealPlanId INT IDENTITY(1,1),
    UserId NVARCHAR(450) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
	CONSTRAINT PK_MealPlans_RecipeIngredientId PRIMARY KEY(MealPlanId), 
    CONSTRAINT FK_MealPlans_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id)
);

END
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'MealPlanEntries')
BEGIN
CREATE TABLE MealPlanEntries (
    MealPlanEntryId INT IDENTITY(1,1),
    MealPlanId INT NOT NULL,
    RecipeId INT NOT NULL,
    MealDate DATE NOT NULL,
    MealType NVARCHAR(50) NOT NULL,
    ServingsToCook INT NOT NULL,
	CONSTRAINT PK_MealPlanEntries_MealPlanEntryId PRIMARY KEY(MealPlanEntryId), 
    CONSTRAINT PK_MealPlanEntries_MealPlans_MealPlanId FOREIGN KEY (MealPlanId) REFERENCES MealPlans(MealPlanId),
    CONSTRAINT PK_MealPlanEntries_Recipes_RecipeId FOREIGN KEY (RecipeId) REFERENCES Recipes(RecipeId)
);

END
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'ShoppingListItems')
BEGIN
CREATE TABLE ShoppingListItems (
    ItemId INT IDENTITY(1,1),
    MealPlanId INT NOT NULL,
    IngredientId INT NOT NULL,
    RequiredQuantity DECIMAL(10, 2) NOT NULL, 
    UnitOfMeasure NVARCHAR(50) NOT NULL,
    IsCheckedOff BIT NOT NULL DEFAULT 0,
	CONSTRAINT PK_ShoppingListItems_ItemId PRIMARY KEY(ItemId), 
    CONSTRAINT PK_ShoppingListItems_MealPlans_MealPlanId FOREIGN KEY (MealPlanId) REFERENCES MealPlans(MealPlanId),
    CONSTRAINT PK_ShoppingListItems_Ingredients_IngredientId FOREIGN KEY (IngredientId) REFERENCES Ingredients(IngredientId)
);

END
GO