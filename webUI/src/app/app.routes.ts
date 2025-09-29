import { Routes } from '@angular/router';

export const routes: Routes = [
  { path: '', redirectTo: 'recipes', pathMatch: 'full' },
  {
    path: 'recipes',
    loadComponent: () =>
      import('./features/recipes/recipe-list/recipe-list').then(
        (m) => m.RecipeListComponent
      ),
  },
  {
    path: 'recipes/:id',
    loadComponent: () =>
      import('./features/recipes/recipe-detail/recipe-detail').then(
        (m) => m.RecipeDetailComponent
      ),
  },
  {
    path: 'meal-plans',
    loadComponent: () =>
      import('./features/meal-plans/meal-plans').then(
        (m) => m.MealPlansComponent
      ),
  },
  {
    path: 'shopping-lists',
    loadComponent: () =>
      import('./features/shopping-lists/shopping-lists').then(
        (m) => m.ShoppingListsComponent
      ),
  },
];
