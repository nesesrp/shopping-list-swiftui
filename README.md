# shopping-list-swiftui

A simple shopping list app written in SwiftUI (MVVM architecture).

## Features

- Add items to the shopping list (name + quantity)
- Mark items as purchased
- Swipe to delete items
- Automatic persistence via `UserDefaults` so the list survives app relaunch
- Informative empty-state screen when the list is empty

## Requirements

- Xcode 15 or later
- iOS 17 or later (SDK)
- Swift 5.9 or later

## Folder Structure

```
ShoppingList/
├── App/
│   └── ShoppingListApp.swift       # @main entry point
├── Models/
│   └── ShoppingItem.swift          # Item data model
├── ViewModels/
│   └── ShoppingListViewModel.swift # List state and business logic
├── Views/
│   ├── ShoppingListView.swift      # Main list screen
│   ├── ShoppingItemRow.swift       # Single row view
│   └── AddItemView.swift           # Add new item form
├── Services/
│   └── PersistenceService.swift    # UserDefaults-based persistence
└── Resources/
    └── Assets.xcassets/            # Visual assets / app icon
```

## Setup and Running

This repository does not include an Xcode `.xcodeproj` file. To run it:

1. Open Xcode and select **File → New → Project → App**.
2. Create the project with product name `ShoppingList`, interface **SwiftUI**,
   and language **Swift**, outside of this repo folder (e.g. in an `Xcode/`
   subfolder).
3. Delete the default `ContentView.swift` and `<Project>App.swift` files from
   the newly created project.
4. Drag and drop the contents of this repo's `ShoppingList/` folder (App,
   Models, ViewModels, Views, Services, Resources) into the Xcode project
   navigator, onto the appropriate target (make sure "Copy items if needed"
   is checked).
5. Select a simulator and run with ⌘R.

## Architecture

The app follows the MVVM (Model-View-ViewModel) pattern:

- **Model** (`ShoppingItem`): A plain data structure, `Codable` for
  persistence.
- **ViewModel** (`ShoppingListViewModel`): Holds `@Published` state and
  business logic (add/remove/toggle), depends on `PersistenceServiceProtocol`
  for persistence (abstracted for testability).
- **View** (`ShoppingListView`, `ShoppingItemRow`, `AddItemView`): SwiftUI
  views that only observe the ViewModel and forward user interactions to it.
- **Service** (`PersistenceService`): Simple persistence via `UserDefaults` +
  `JSONEncoder`/`JSONDecoder`; can be swapped for Core Data / SwiftData later.
