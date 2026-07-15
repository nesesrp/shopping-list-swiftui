# shopping-list-swiftui

A simple shopping list app written in SwiftUI (MVVM architecture).

## Features

- Add items to the shopping list (name + quantity + category)
- Edit existing items (tap a row to change name, quantity, or category)
- Mark items as purchased
- Group items into sections by category
- Search/filter items by name
- Clear all checked (purchased) items in one tap
- Swipe to delete items
- Automatic persistence via `UserDefaults` so the list survives app relaunch
- Informative empty-state screen when the list is empty or a search has no results

## Requirements

- Xcode 15 or later
- iOS 17 or later (SDK)
- Swift 5.9 or later
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`) to generate the `.xcodeproj`

## Folder Structure

```
ShoppingList/
├── App/
│   └── ShoppingListApp.swift       # @main entry point
├── Models/
│   ├── ShoppingItem.swift          # Item data model
│   └── Category.swift              # Item category enum
├── ViewModels/
│   └── ShoppingListViewModel.swift # List state and business logic
├── Views/
│   ├── ShoppingListView.swift      # Main list screen
│   ├── ShoppingItemRow.swift       # Single row view
│   └── AddItemView.swift           # Add/edit item form
├── Services/
│   └── PersistenceService.swift    # UserDefaults-based persistence
└── Resources/
    └── Assets.xcassets/            # Visual assets / app icon

ShoppingListTests/
├── ShoppingListViewModelTests.swift # ViewModel unit tests
└── MockPersistenceService.swift     # In-memory persistence test double
```

## Setup and Running

This repository does not track the generated `.xcodeproj` — it's produced from
[`project.yml`](project.yml) via XcodeGen. To run it:

1. Install XcodeGen if you don't have it: `brew install xcodegen`.
2. From the repo root, run `xcodegen generate`. This creates
   `ShoppingList.xcodeproj`.
3. Open `ShoppingList.xcodeproj` in Xcode.
4. Select a simulator and run with ⌘R.

Re-run `xcodegen generate` whenever `project.yml` changes or new source files
are added.

## Running Tests

Run the `ShoppingListTests` unit test target from Xcode with ⌘U, or from the
command line:

```
xcodebuild -project ShoppingList.xcodeproj -scheme ShoppingList \
  -destination 'platform=iOS Simulator,name=iPhone 16' test
```

## Architecture

The app follows the MVVM (Model-View-ViewModel) pattern:

- **Model** (`ShoppingItem`, `Category`): Plain data structures, `Codable`
  for persistence.
- **ViewModel** (`ShoppingListViewModel`): Holds `@Published` state and
  business logic (add/edit/remove/toggle/clear-checked/group-by-category/
  search), depends on `PersistenceServiceProtocol` for persistence
  (abstracted for testability, see `ShoppingListTests`).
- **View** (`ShoppingListView`, `ShoppingItemRow`, `AddItemView`): SwiftUI
  views that only observe the ViewModel and forward user interactions to it.
- **Service** (`PersistenceService`): Simple persistence via `UserDefaults` +
  `JSONEncoder`/`JSONDecoder`; can be swapped for Core Data / SwiftData later.
