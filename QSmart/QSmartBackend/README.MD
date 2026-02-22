# QsmartBackend - Getting Started

This document explains how to create, apply, and generate SQL scripts using Entity Framework Core migrations.

---

## 📦 Prerequisites

Ensure you have the following installed:

- .NET SDK (8.0 or later)
- EF Core CLI tools
```bash
  dotnet tool install --global dotnet-ef
```

## Appsettings.json Configuration
Make sure your `appsettings.json` file is properly configured with the correct connection string for your database. Example:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=<your server instance>;Database=QSmartDB;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

## 🚀 Database Setup

Run the following command from the project directory to create the database:
```bash
dotnet ef migrations add <MigrationName> --context AppDbContext
dotnet ef database update --context AppDbContext
```

## Running the application
To run the application, navigate to the project directory and use the following command:
```bash
dotnet run
```