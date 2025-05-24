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
- **Managers**: Handle persistence (FavoritesManager), notifications, and secure secrets loading

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
├── secrets.plist
├── SecretsManager.swift
└── QuoteOfTheDayApp.swift
```

## Setup

1. Clone the repo
2. Open in Xcode 15+
3. Add your API key from [API Ninjas](https://api-ninjas.com/api/quotes) into `secrets.plist` as a key named `API_KEY`
4. Build and run

## Credits

Built by José Luís — 2025.
