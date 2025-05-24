# Quote of the Day

Quote of the Day is a beautifully designed SwiftUI app that delivers daily inspirational quotes. Built with Swift, SwiftUI, and clean MVVM architecture, this app emphasizes simplicity, performance, and user experience.

## Features

- Get a new quote every day
- Save your favorite quotes
- Switch between light and dark themes
- Use the hamburger menu for intuitive navigation
- Built with MVVM for clean separation of logic and UI
- Fetches quotes from a live API (API Ninjas)

## Architecture

This app uses the MVVM (Model-View-ViewModel) architecture pattern.

- **Models**: Represent quote data
- **Views**: Handle UI presentation
- **ViewModels**: Manage logic and data fetching
- **Managers**: Handle persistence (FavoritesManager) and notifications

## Tech Stack

- SwiftUI
- Combine
- URLSession
- UserDefaults for persistence
- Local Notifications (daily random time)

## Folder Structure

```
QuoteOfTheDay/
├── Models/
│   └── Quote.swift
├── Networking/
│   └── QuoteService.swift
├── ViewModels/
│   └── QuoteViewModel.swift
├── Views/
│   ├── QuoteView.swift
│   ├── FavoritesView.swift
│   ├── MainView.swift
│   └── MenuView.swift
├── Assets/
├── FavoritesManager.swift
├── NotificationManager.swift
├── SecretsManager.swift
├── secrets.plist (not tracked in Git)
└── QuoteOfTheDayApp.swift
```

## Setup

1. Clone the repo
2. Open in Xcode 15+
3. Create a `secrets.plist` file at the root of the project with the following key:
   - `API_KEY`: your API key from [API Ninjas](https://api-ninjas.com/api/quotes)
4. Make sure the `secrets.plist` file is not tracked in version control (it's included in `.gitignore`)
5. Build and run

## Credits

Built by José Luís — 2025.
