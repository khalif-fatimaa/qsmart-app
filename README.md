# QSmart

> Full-stack system with .NET backend, Blazor dashboard, and Flutter mobile app

## Overview
QSmart is a full-stack recovery and monitoring platform designed to simulate sensor-driven health insights. The system collects posture, tension, and activity data (mocked) and visualizes it through web and mobile applications.

This project demonstrates end-to-end system design across backend APIs, web dashboards, and mobile applications.

## My Contribution
- Contributed to full-stack development across backend API, web dashboard, and mobile application  
- Assisted with feature implementation, debugging, and system integration  
- Worked on improving application performance and overall functionality  

## Key Features
- Full-stack architecture with API, web, and mobile integration  
- Real-time data visualization and user insights  
- Admin dashboard for monitoring and management  
- Cross-platform mobile application for end users  

## Tech Stack
- Backend: C# / .NET 8  
- Web: Blazor  
- Mobile: Flutter (Dart)  
- Database: SQL Server  
- Tools: Visual Studio, Android Studio  

## Architecture
The system consists of three main components:

- Backend API (.NET) – handles data processing and business logic  
- Web Dashboard (Blazor) – admin/staff interface  
- Mobile App (Flutter) – end-user interaction  

All components communicate through the backend API.

## Repository Structure
- QSmart/ → Backend API (.NET 8)  
- qSmartWebDashboard/ → Web dashboard (Blazor)  
- qsmart_mobile/ → Mobile application (Flutter/Dart)  

Each component can run independently, but the backend API must be running for full functionality.

## Screenshots (optional)
_Add screenshots here if available_

---

## System Overview
QSmart is a sensor-driven recovery platform that collects posture, tension, and activity data (mocked for this project) and visualizes recovery insights through:

- A .NET backend API  
- A Blazor Web Dashboard (admin/staff)  
- A Flutter Mobile App (end users)  

All components are designed to work together locally.

---

## Prerequisites

### Required Software
- Git  
- .NET SDK 8  
- Visual Studio 2022 (ASP.NET workload)  
- Flutter SDK  
- Android Studio (or Android SDK + emulator)  

### Recommended Tools
- Visual Studio Code (for mobile development)

> Note: iOS builds require macOS and Xcode. Android is recommended for local development.

---

## Quick Start (Recommended Order)

1. Run the backend API  
2. Run the web dashboard  
3. Run the mobile app  

⚠️ The backend API must be running first.

---

## Backend Setup (.NET API)

1. Open solution:
   `QSmart/QSmart.sln`

2. Restore NuGet packages

3. Run using:
   - Visual Studio → IIS Express or HTTP profile  

4. Verify:
   - Swagger UI should open in browser  

---

## Web Dashboard Setup (Blazor)

1. Open solution:
   `qSmartWebDashboard/qSmartWebDashboard.sln`

2. Restore packages  

3. Run the project  

4. Confirm it connects to backend API  

---

## Mobile App Setup (Flutter)

```bash
cd qsmart_mobile
flutter pub get
flutter run
