# 2025-Sep-QSmart

# QSmart – Developer Setup & Transition Guide

This repository contains the complete QSmart system developed as part of the
DMIT-2590 Capstone project.

The purpose of this README is to act as a **developer setup and transition guide**.
A new team member should be able to go from **zero → running the system locally**
and contributing code using only this document.

---

## System Overview

QSmart is a sensor-driven recovery platform that collects posture, tension, and
activity data (mocked for this project) and visualizes recovery insights through:

- A .NET backend API
- A Blazor Web Dashboard (admin/staff)
- A Flutter Mobile App (end users)

All components are designed to work together locally.

---

## Repository Structure

QSmart/ → Backend API (.NET 8)
qSmartWebDashboard/ → Web dashboard (Blazor)
qsmart_mobile/ → Mobile application (Flutter/Dart)


Each component has its own solution/project files and can be run independently,
but the backend API must be running for the web and mobile apps to function correctly.

---

## Prerequisites

Install the following before starting:

### Required Software
- **Git**
- **.NET SDK 8**
- **Visual Studio 2022** (ASP.NET workload)
- **Flutter SDK**
- **Android Studio** (or Android SDK + emulator)

### Recommended Tools
- **Visual Studio Code** (used for Flutter/mobile development)

> Note: iOS builds require macOS and Xcode. Android is recommended for local development.

---

## Quick Start (Recommended Order)

1. Run the backend API
2. Run the web dashboard
3. Run the mobile app

The backend API must be running first.

Once all three components are running locally, a new developer is fully set up
and can begin contributing code to any part of the system.


---

## Backend Setup (.NET API)

1. Open the solution:
QSmart/QSmart.sln



1. Restore NuGet packages (Visual Studio will prompt automatically).

2. Run the project using:
- Visual Studio → IIS Express or HTTP profile

1. Verify the API is running:
- Swagger UI should open automatically in the browser.

If Swagger loads successfully, the backend is ready.

---

## Web Dashboard Setup (Blazor)

1. Open the solution:
qSmartWebDashboard/qSmartWebDashboard.sln


1. Restore NuGet packages.

2. Run the project in Visual Studio.

3. Confirm the dashboard loads in the browser and can communicate with the backend API.

---

## Mobile App Setup (Flutter)

1. Navigate to the mobile app directory:
cd qsmart_mobile



1. Install dependencies:
flutter pub get



1. Start an Android emulator (recommended).

2. Run the app:
flutter run


### API Connection Note (Important)

- When running on an **Android emulator**, the backend base URL must use:
http://10.0.2.2


instead of `localhost`.

See `qsmart_mobile/README.md` for mobile-specific details.

---

## Configuration & Secrets

- No production credentials or secrets are stored in this repository.
- All configuration values are intended for local development only.
- Sensitive values (keys, accounts, passwords) must be provided separately
and **must not be committed to the repository**.

If additional credentials are required, they should be documented in a separate
transition document and shared securely.

---

## Contributing Guidelines

- Create feature branches off `main`
- Submit changes via Pull Requests
- At least one team member review is required before merging
- Do not commit secrets or environment-specific files

---

## Troubleshooting

- Ensure the backend API is running before starting the web or mobile apps
- Verify no required ports are already in use
- Restart the Android emulator if the mobile app cannot connect to the API

---

## Additional Documentation

- Mobile app details: `qsmart_mobile/README.md`
- Client-facing usage instructions are provided separately

