CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
    `MigrationId` varchar(150) NOT NULL,
    `ProductVersion` varchar(32) NOT NULL,
    PRIMARY KEY (`MigrationId`)
);

START TRANSACTION;
IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `aspnetusers` (
        `Id` varchar(255) NOT NULL,
        `ProfileImageUrl` longtext NULL,
        `FavoriteCuisine` longtext NULL,
        `DateJoined` datetime(6) NOT NULL,
        `UserName` varchar(256) NULL,
        `NormalizedUserName` varchar(256) NULL,
        `Email` varchar(256) NULL,
        `NormalizedEmail` varchar(256) NULL,
        `EmailConfirmed` tinyint(1) NOT NULL,
        `PasswordHash` longtext NULL,
        `SecurityStamp` longtext NULL,
        `ConcurrencyStamp` longtext NULL,
        `PhoneNumber` longtext NULL,
        `PhoneNumberConfirmed` tinyint(1) NOT NULL,
        `TwoFactorEnabled` tinyint(1) NOT NULL,
        `LockoutEnd` datetime NULL,
        `LockoutEnabled` tinyint(1) NOT NULL,
        `AccessFailedCount` int NOT NULL,
        PRIMARY KEY (`Id`)
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `Ingredients` (
        `IngredientId` int NOT NULL AUTO_INCREMENT,
        `Name` varchar(100) NOT NULL,
        `AisleCategory` varchar(50) NULL,
        PRIMARY KEY (`IngredientId`)
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `Tags` (
        `TagId` int NOT NULL AUTO_INCREMENT,
        `TagName` varchar(50) NOT NULL,
        PRIMARY KEY (`TagId`)
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `AspNetUserClaims` (
        `Id` int NOT NULL AUTO_INCREMENT,
        `UserId` varchar(255) NOT NULL,
        `ClaimType` longtext NULL,
        `ClaimValue` longtext NULL,
        PRIMARY KEY (`Id`),
        CONSTRAINT `FK_AspNetUserClaims_aspnetusers_UserId` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `aspnetuserlogins` (
        `LoginProvider` varchar(255) NOT NULL,
        `ProviderKey` varchar(255) NOT NULL,
        `ProviderDisplayName` longtext NULL,
        `UserId` varchar(255) NOT NULL,
        PRIMARY KEY (`LoginProvider`, `ProviderKey`),
        CONSTRAINT `FK_aspnetuserlogins_aspnetusers_UserId` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `AspNetUserTokens` (
        `UserId` varchar(255) NOT NULL,
        `LoginProvider` varchar(255) NOT NULL,
        `Name` varchar(255) NOT NULL,
        `Value` longtext NULL,
        PRIMARY KEY (`UserId`, `LoginProvider`, `Name`),
        CONSTRAINT `FK_AspNetUserTokens_aspnetusers_UserId` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `MealPlans` (
        `MealPlanId` int NOT NULL AUTO_INCREMENT,
        `UserId` varchar(255) NOT NULL,
        `Name` varchar(100) NOT NULL,
        `StartDate` date NOT NULL,
        `EndDate` date NOT NULL,
        `IsActive` tinyint(1) NOT NULL,
        PRIMARY KEY (`MealPlanId`),
        CONSTRAINT `FK_MealPlans_aspnetusers_UserId` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `Recipes` (
        `RecipeId` int NOT NULL AUTO_INCREMENT,
        `OwnerId` varchar(255) NOT NULL,
        `Title` varchar(250) NOT NULL,
        `Instructions` longtext NOT NULL,
        `PrepTimeMinutes` int NULL,
        `CookTimeMinutes` int NULL,
        `Servings` int NULL,
        `ImageUrl` longtext NULL,
        PRIMARY KEY (`RecipeId`),
        CONSTRAINT `FK_Recipes_aspnetusers_OwnerId` FOREIGN KEY (`OwnerId`) REFERENCES `aspnetusers` (`Id`) ON DELETE RESTRICT
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `ShoppingListItems` (
        `ItemId` int NOT NULL AUTO_INCREMENT,
        `MealPlanId` int NOT NULL,
        `IngredientId` int NOT NULL,
        `RequiredQuantity` decimal(10,2) NOT NULL,
        `UnitOfMeasure` varchar(50) NOT NULL,
        `IsCheckedOff` tinyint(1) NOT NULL,
        PRIMARY KEY (`ItemId`),
        CONSTRAINT `FK_ShoppingListItems_Ingredients_IngredientId` FOREIGN KEY (`IngredientId`) REFERENCES `Ingredients` (`IngredientId`) ON DELETE CASCADE,
        CONSTRAINT `FK_ShoppingListItems_MealPlans_MealPlanId` FOREIGN KEY (`MealPlanId`) REFERENCES `MealPlans` (`MealPlanId`) ON DELETE CASCADE
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `MealPlanEntries` (
        `MealPlanEntryId` int NOT NULL AUTO_INCREMENT,
        `MealPlanId` int NOT NULL,
        `RecipeId` int NOT NULL,
        `MealDate` date NOT NULL,
        `MealType` varchar(50) NOT NULL,
        `ServingsToCook` int NOT NULL,
        PRIMARY KEY (`MealPlanEntryId`),
        CONSTRAINT `FK_MealPlanEntries_MealPlans_MealPlanId` FOREIGN KEY (`MealPlanId`) REFERENCES `MealPlans` (`MealPlanId`) ON DELETE CASCADE,
        CONSTRAINT `FK_MealPlanEntries_Recipes_RecipeId` FOREIGN KEY (`RecipeId`) REFERENCES `Recipes` (`RecipeId`) ON DELETE CASCADE
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `RecipeIngredients` (
        `RecipeIngredientId` int NOT NULL AUTO_INCREMENT,
        `RecipeId` int NOT NULL,
        `IngredientId` int NOT NULL,
        `QuantityValue` decimal(10,2) NOT NULL,
        `QuantityUnit` varchar(50) NOT NULL,
        `Notes` longtext NULL,
        PRIMARY KEY (`RecipeIngredientId`),
        CONSTRAINT `FK_RecipeIngredients_Ingredients_IngredientId` FOREIGN KEY (`IngredientId`) REFERENCES `Ingredients` (`IngredientId`) ON DELETE CASCADE,
        CONSTRAINT `FK_RecipeIngredients_Recipes_RecipeId` FOREIGN KEY (`RecipeId`) REFERENCES `Recipes` (`RecipeId`) ON DELETE CASCADE
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE TABLE `RecipeTags` (
        `RecipeId` int NOT NULL,
        `TagId` int NOT NULL,
        PRIMARY KEY (`RecipeId`, `TagId`),
        CONSTRAINT `FK_RecipeTags_Recipes_RecipeId` FOREIGN KEY (`RecipeId`) REFERENCES `Recipes` (`RecipeId`) ON DELETE CASCADE,
        CONSTRAINT `FK_RecipeTags_Tags_TagId` FOREIGN KEY (`TagId`) REFERENCES `Tags` (`TagId`) ON DELETE CASCADE
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_AspNetUserClaims_UserId` ON `AspNetUserClaims` (`UserId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_aspnetuserlogins_UserId` ON `aspnetuserlogins` (`UserId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `EmailIndex` ON `aspnetusers` (`NormalizedEmail`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE UNIQUE INDEX `UserNameIndex` ON `aspnetusers` (`NormalizedUserName`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_MealPlanEntries_MealPlanId` ON `MealPlanEntries` (`MealPlanId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_MealPlanEntries_RecipeId` ON `MealPlanEntries` (`RecipeId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_MealPlans_UserId` ON `MealPlans` (`UserId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_RecipeIngredients_IngredientId` ON `RecipeIngredients` (`IngredientId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE UNIQUE INDEX `IX_RecipeIngredients_RecipeId_IngredientId` ON `RecipeIngredients` (`RecipeId`, `IngredientId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_Recipes_OwnerId` ON `Recipes` (`OwnerId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_RecipeTags_TagId` ON `RecipeTags` (`TagId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_ShoppingListItems_IngredientId` ON `ShoppingListItems` (`IngredientId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    CREATE INDEX `IX_ShoppingListItems_MealPlanId` ON `ShoppingListItems` (`MealPlanId`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20250929192939_InitialSetup')
BEGIN
    INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
    VALUES ('20250929192939_InitialSetup', '9.0.9');
END;

COMMIT;

