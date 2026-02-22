-- Create the database
CREATE DATABASE QSmartDB;
GO

-- Use the database
USE QSmartDB;
GO

-- =========================
-- USERS TABLE
-- =========================
CREATE TABLE dbo.Users (
    UserID NVARCHAR(50) PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    PasswordHash NVARCHAR(200),
    CreatedAt DATETIME
);
GO

-- =========================
-- SESSIONS TABLE
-- =========================
CREATE TABLE dbo.Sessions (
    SessionID NVARCHAR(50) PRIMARY KEY,
    UserID NVARCHAR(50) NOT NULL,
    StartedAt DATETIME,
    Notes NVARCHAR(MAX),
    Region NVARCHAR(100),
    TensionScore FLOAT,
    HeartRateBpm FLOAT,
    PostureAngleDegree FLOAT,
    ActivityLabel NVARCHAR(100),
    CONSTRAINT FK_Sessions_Users FOREIGN KEY (UserID)
      REFERENCES dbo.Users(UserID)
);
GO

-- =========================
-- READINGS TABLE
-- =========================
CREATE TABLE dbo.Readings (
    UserID NVARCHAR(50) NOT NULL,
    SessionID NVARCHAR(50) NOT NULL,
    CreatedAt DateTime,
    Region NVARCHAR(100),
    TensionScore FLOAT,
    HeartRateBpm FLOAT,
    PostureAngleDegree FLOAT,
    ActivityLabel NVARCHAR(100),
    SkinTempC FLOAT,
    GsrUs FLOAT,
    RespirationBpm FLOAT,
    Spo2Pct FLOAT,
    EmgUv FLOAT,
    AccelXYZ NVARCHAR(100),
    GyroDps NVARCHAR(100),
    PressureKpa FLOAT,
    AmbientTempC FLOAT,
    HumidityPct FLOAT,
    NoiseDb FLOAT,
    StressIndex FLOAT,
    CumulativeTensionLoad FLOAT,
    RecoveryScore FLOAT,
    CONSTRAINT PK_Readings PRIMARY KEY (UserID, SessionID),
    CONSTRAINT FK_Readings_Users FOREIGN KEY (UserID)
      REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Readings_Sessions FOREIGN KEY (SessionID)
      REFERENCES dbo.Sessions(SessionID)
);
GO
