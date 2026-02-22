-- =========================
-- SEED DATA FOR QSmartDB
-- =========================

USE QSmartDB;
GO

-- =========================
-- SEED USERS TABLE
-- =========================
INSERT INTO dbo.Users (UserID, FullName, Email, CreatedAt)
VALUES
    ('USR001', 'Emma Thompson', 'emma.thompson@email.com', '2024-01-15 09:30:00'),
    ('USR002', 'James Rodriguez', 'james.rodriguez@email.com', '2024-01-20 14:22:00'),
    ('USR003', 'Sophia Chen', 'sophia.chen@email.com', '2024-02-03 11:45:00'),
    ('USR004', 'Michael O''Brien', 'michael.obrien@email.com', '2024-02-10 16:10:00'),
    ('USR005', 'Aisha Patel', 'aisha.patel@email.com', '2024-02-18 08:55:00'),
    ('USR006', 'David Kim', 'david.kim@email.com', '2024-03-05 13:40:00'),
    ('USR007', 'Isabella Martinez', 'isabella.martinez@email.com', '2024-03-12 10:20:00'),
    ('USR008', 'Ryan Murphy', 'ryan.murphy@email.com', '2024-03-25 15:30:00'),
    ('USR009', 'Olivia Johnson', 'olivia.johnson@email.com', '2024-04-02 09:15:00'),
    ('USR010', 'Lucas Santos', 'lucas.santos@email.com', '2024-04-15 12:05:00');
GO

-- =========================
-- SEED SESSIONS TABLE
-- =========================
INSERT INTO dbo.Sessions (SessionID, UserID, StartedAt, Notes, Region, TensionScore, HeartRateBpm, PostureAngleDegree, ActivityLabel)
VALUES
    -- User USR001 sessions
    ('SES001', 'USR001', '2024-10-01 09:00:00', 'Morning workout session', 'Upper Back', 6.5, 110.0, 15.2, 'Exercise'),
    ('SES002', 'USR001', '2024-10-02 14:30:00', 'Office work - long meeting', 'Neck', 7.8, 75.0, 22.5, 'Sitting'),
    ('SES003', 'USR001', '2024-10-05 08:15:00', 'Yoga session', 'Lower Back', 3.2, 68.0, 8.5, 'Stretching'),
    
    -- User USR002 sessions
    ('SES004', 'USR002', '2024-10-01 10:30:00', 'Standing desk work', 'Shoulders', 5.5, 72.0, 12.0, 'Standing'),
    ('SES005', 'USR002', '2024-10-03 16:00:00', 'Cycling commute', 'Lower Back', 4.8, 125.0, 18.0, 'Cycling'),
    ('SES006', 'USR002', '2024-10-06 13:45:00', 'Conference call', 'Neck', 6.9, 78.0, 20.3, 'Sitting'),
    
    -- User USR003 sessions
    ('SES007', 'USR003', '2024-10-02 07:30:00', 'Early morning run', 'Legs', 5.2, 145.0, 10.5, 'Running'),
    ('SES008', 'USR003', '2024-10-04 11:00:00', 'Focused coding session', 'Upper Back', 7.2, 70.0, 25.0, 'Sitting'),
    ('SES009', 'USR003', '2024-10-07 19:00:00', 'Evening relaxation', 'Neck', 2.8, 65.0, 5.0, 'Resting'),
    
    -- User USR004 sessions
    ('SES010', 'USR004', '2024-10-01 12:00:00', 'Lunch break walk', 'Lower Back', 3.5, 85.0, 8.0, 'Walking'),
    ('SES011', 'USR004', '2024-10-03 09:30:00', 'Client presentation', 'Shoulders', 8.5, 88.0, 23.5, 'Standing'),
    ('SES012', 'USR004', '2024-10-05 15:20:00', 'Deep work session', 'Neck', 7.5, 73.0, 28.0, 'Sitting'),
    
    -- User USR005 sessions
    ('SES013', 'USR005', '2024-10-02 08:00:00', 'Pilates class', 'Core', 4.2, 95.0, 12.8, 'Exercise'),
    ('SES014', 'USR005', '2024-10-04 14:00:00', 'Video editing work', 'Upper Back', 6.8, 71.0, 22.0, 'Sitting'),
    ('SES015', 'USR005', '2024-10-06 17:30:00', 'Team building activity', 'Legs', 5.8, 105.0, 15.0, 'Walking'),
    
    -- User USR006 sessions
    ('SES016', 'USR006', '2024-10-01 11:15:00', 'Design sprint', 'Neck', 7.0, 76.0, 24.5, 'Sitting'),
    ('SES017', 'USR006', '2024-10-03 08:45:00', 'Swimming session', 'Shoulders', 4.5, 115.0, 10.0, 'Swimming'),
    ('SES018', 'USR006', '2024-10-07 13:00:00', 'Brainstorming meeting', 'Upper Back', 6.2, 80.0, 18.5, 'Sitting'),
    
    -- User USR007 sessions
    ('SES019', 'USR007', '2024-10-02 10:00:00', 'Teaching session', 'Lower Back', 5.9, 82.0, 16.5, 'Standing'),
    ('SES020', 'USR007', '2024-10-04 16:30:00', 'Research work', 'Neck', 8.2, 74.0, 26.8, 'Sitting'),
    ('SES021', 'USR007', '2024-10-06 07:00:00', 'Morning meditation', 'Core', 2.5, 62.0, 3.5, 'Sitting'),
    
    -- User USR008 sessions
    ('SES022', 'USR008', '2024-10-01 15:45:00', 'Weight training', 'Shoulders', 6.8, 130.0, 14.0, 'Exercise'),
    ('SES023', 'USR008', '2024-10-03 12:30:00', 'Sales calls', 'Neck', 7.3, 79.0, 21.5, 'Sitting'),
    ('SES024', 'USR008', '2024-10-05 18:00:00', 'Evening walk', 'Lower Back', 3.8, 90.0, 9.0, 'Walking'),
    
    -- User USR009 sessions
    ('SES025', 'USR009', '2024-10-02 09:30:00', 'Dance class', 'Legs', 5.5, 120.0, 13.5, 'Dancing'),
    ('SES026', 'USR009', '2024-10-04 13:15:00', 'Writing session', 'Upper Back', 6.5, 69.0, 23.0, 'Sitting'),
    ('SES027', 'USR009', '2024-10-07 10:45:00', 'Team meeting', 'Neck', 6.0, 77.0, 19.0, 'Sitting'),
    
    -- User USR010 sessions
    ('SES028', 'USR010', '2024-10-01 08:30:00', 'Rock climbing', 'Upper Back', 7.5, 135.0, 20.0, 'Climbing'),
    ('SES029', 'USR010', '2024-10-03 14:45:00', 'Data analysis', 'Neck', 7.8, 72.0, 27.5, 'Sitting'),
    ('SES030', 'USR010', '2024-10-06 11:30:00', 'Stretching routine', 'Lower Back', 3.0, 66.0, 6.5, 'Stretching');
GO

-- =========================
-- SEED READINGS TABLE
-- =========================
INSERT INTO dbo.Readings (
    UserID, SessionID, CreatedAt, Region, TensionScore, HeartRateBpm, PostureAngleDegree, 
    ActivityLabel, SkinTempC, GsrUs, RespirationBpm, Spo2Pct, EmgUv, AccelXYZ, 
    GyroDps, PressureKpa, AmbientTempC, HumidityPct, NoiseDb, StressIndex, 
    CumulativeTensionLoad, RecoveryScore
)
VALUES
    -- Readings for SES001
    ('USR001', 'SES001', '2024-10-01 09:00:00', 'Upper Back', 6.5, 110.0, 15.2, 'Exercise', 
     34.2, 8.5, 22.0, 97.5, 125.0, '0.8,0.3,-9.8', '2.5,1.2,0.8', 101.2, 22.5, 45.0, 65.0, 4.2, 125.5, 75.0),
    
    -- Readings for SES002
    ('USR001', 'SES002', '2024-10-02 14:30:00', 'Neck', 7.8, 75.0, 22.5, 'Sitting', 
     33.8, 12.3, 16.0, 98.2, 85.0, '0.1,0.2,-9.8', '0.3,0.5,0.2', 101.5, 23.0, 48.0, 55.0, 6.5, 185.2, 62.0),
    
    -- Readings for SES003
    ('USR001', 'SES003', '2024-10-05 08:15:00', 'Lower Back', 3.2, 68.0, 8.5, 'Stretching', 
     33.5, 5.2, 12.0, 98.8, 45.0, '0.2,0.1,-9.8', '0.8,0.3,0.1', 101.0, 21.0, 42.0, 48.0, 2.8, 65.0, 88.0),
    
    -- Readings for SES004
    ('USR002', 'SES004', '2024-10-01 10:30:00', 'Shoulders', 5.5, 72.0, 12.0, 'Standing', 
     33.9, 7.8, 15.0, 98.0, 68.0, '0.3,0.4,-9.8', '1.2,0.8,0.5', 101.3, 22.0, 46.0, 52.0, 3.8, 95.0, 78.0),
    
    -- Readings for SES005
    ('USR002', 'SES005', '2024-10-03 16:00:00', 'Lower Back', 4.8, 125.0, 18.0, 'Cycling', 
     34.5, 9.2, 25.0, 97.0, 95.0, '1.5,0.8,-9.5', '5.2,3.8,2.1', 101.8, 20.0, 35.0, 70.0, 4.5, 110.0, 72.0),
    
    -- Readings for SES006
    ('USR002', 'SES006', '2024-10-06 13:45:00', 'Neck', 6.9, 78.0, 20.3, 'Sitting', 
     33.7, 11.5, 17.0, 98.5, 78.0, '0.2,0.3,-9.8', '0.5,0.6,0.3', 101.4, 23.5, 50.0, 58.0, 5.8, 155.0, 65.0),
    
    -- Readings for SES007
    ('USR003', 'SES007', '2024-10-02 07:30:00', 'Legs', 5.2, 145.0, 10.5, 'Running', 
     35.0, 10.5, 32.0, 96.5, 135.0, '2.5,1.8,-9.2', '8.5,6.2,3.5', 102.0, 18.0, 38.0, 68.0, 5.0, 125.0, 68.0),
    
    -- Readings for SES008
    ('USR003', 'SES008', '2024-10-04 11:00:00', 'Upper Back', 7.2, 70.0, 25.0, 'Sitting', 
     33.6, 13.0, 15.0, 98.8, 88.0, '0.1,0.2,-9.8', '0.2,0.4,0.2', 101.2, 24.0, 52.0, 60.0, 6.8, 195.0, 58.0),
    
    -- Readings for SES009
    ('USR003', 'SES009', '2024-10-07 19:00:00', 'Neck', 2.8, 65.0, 5.0, 'Resting', 
     33.2, 4.5, 10.0, 99.0, 35.0, '0.0,0.1,-9.8', '0.1,0.1,0.0', 101.0, 22.0, 44.0, 38.0, 2.2, 45.0, 92.0),
    
    -- Readings for SES010
    ('USR004', 'SES010', '2024-10-01 12:00:00', 'Lower Back', 3.5, 85.0, 8.0, 'Walking', 
     34.0, 6.8, 18.0, 98.0, 55.0, '0.8,0.5,-9.6', '2.8,2.0,1.5', 101.5, 23.0, 40.0, 62.0, 3.2, 75.0, 82.0),
    
    -- Readings for SES011
    ('USR004', 'SES011', '2024-10-03 09:30:00', 'Shoulders', 8.5, 88.0, 23.5, 'Standing', 
     34.2, 14.5, 20.0, 97.5, 105.0, '0.4,0.5,-9.7', '1.5,1.2,0.8', 101.6, 23.5, 48.0, 72.0, 7.5, 225.0, 52.0),
    
    -- Readings for SES012
    ('USR004', 'SES012', '2024-10-05 15:20:00', 'Neck', 7.5, 73.0, 28.0, 'Sitting', 
     33.8, 12.8, 16.0, 98.2, 92.0, '0.1,0.3,-9.8', '0.3,0.5,0.3', 101.3, 24.0, 51.0, 62.0, 6.8, 188.0, 60.0),
    
    -- Readings for SES013
    ('USR005', 'SES013', '2024-10-02 08:00:00', 'Core', 4.2, 95.0, 12.8, 'Exercise', 
     34.3, 8.0, 20.0, 97.8, 85.0, '1.2,0.8,-9.5', '3.5,2.8,1.8', 101.4, 21.5, 43.0, 55.0, 3.8, 98.0, 76.0),
    
    -- Readings for SES014
    ('USR005', 'SES014', '2024-10-04 14:00:00', 'Upper Back', 6.8, 71.0, 22.0, 'Sitting', 
     33.7, 11.2, 15.5, 98.5, 80.0, '0.2,0.2,-9.8', '0.4,0.5,0.2', 101.2, 23.5, 49.0, 56.0, 5.5, 165.0, 66.0),
    
    -- Readings for SES015
    ('USR005', 'SES015', '2024-10-06 17:30:00', 'Legs', 5.8, 105.0, 15.0, 'Walking', 
     34.4, 9.5, 22.0, 97.2, 75.0, '1.0,0.7,-9.6', '3.2,2.5,1.8', 101.6, 22.0, 41.0, 66.0, 4.5, 128.0, 70.0),
    
    -- Readings for SES016
    ('USR006', 'SES016', '2024-10-01 11:15:00', 'Neck', 7.0, 76.0, 24.5, 'Sitting', 
     33.8, 11.8, 16.5, 98.3, 82.0, '0.1,0.3,-9.8', '0.4,0.6,0.3', 101.3, 23.8, 50.5, 58.0, 6.0, 172.0, 64.0),
    
    -- Readings for SES017
    ('USR006', 'SES017', '2024-10-03 08:45:00', 'Shoulders', 4.5, 115.0, 10.0, 'Swimming', 
     34.8, 7.5, 28.0, 97.0, 98.0, '1.8,1.2,-9.3', '6.5,5.0,3.2', 102.2, 25.0, 65.0, 58.0, 4.2, 105.0, 74.0),
    
    -- Readings for SES018
    ('USR006', 'SES018', '2024-10-07 13:00:00', 'Upper Back', 6.2, 80.0, 18.5, 'Sitting', 
     33.9, 10.5, 17.0, 98.0, 72.0, '0.2,0.3,-9.8', '0.5,0.7,0.3', 101.4, 23.0, 47.0, 54.0, 5.2, 148.0, 68.0),
    
    -- Readings for SES019
    ('USR007', 'SES019', '2024-10-02 10:00:00', 'Lower Back', 5.9, 82.0, 16.5, 'Standing', 
     34.0, 9.8, 18.5, 97.8, 70.0, '0.5,0.4,-9.7', '1.8,1.5,0.9', 101.5, 22.5, 46.0, 52.0, 4.8, 138.0, 72.0),
    
    -- Readings for SES020
    ('USR007', 'SES020', '2024-10-04 16:30:00', 'Neck', 8.2, 74.0, 26.8, 'Sitting', 
     33.7, 13.5, 16.0, 98.5, 95.0, '0.1,0.2,-9.8', '0.3,0.4,0.2', 101.2, 24.0, 51.5, 65.0, 7.2, 215.0, 55.0),
    
    -- Readings for SES021
    ('USR007', 'SES021', '2024-10-06 07:00:00', 'Core', 2.5, 62.0, 3.5, 'Sitting', 
     33.1, 3.8, 8.0, 99.2, 28.0, '0.0,0.1,-9.8', '0.1,0.1,0.1', 100.8, 21.0, 42.0, 32.0, 1.8, 38.0, 95.0),
    
    -- Readings for SES022
    ('USR008', 'SES022', '2024-10-01 15:45:00', 'Shoulders', 6.8, 130.0, 14.0, 'Exercise', 
     34.8, 11.0, 26.0, 96.8, 145.0, '2.2,1.5,-9.4', '7.2,5.8,3.8', 102.5, 21.0, 38.0, 70.0, 5.5, 165.0, 66.0),
    
    -- Readings for SES023
    ('USR008', 'SES023', '2024-10-03 12:30:00', 'Neck', 7.3, 79.0, 21.5, 'Sitting', 
     33.8, 12.0, 17.0, 98.0, 86.0, '0.2,0.3,-9.8', '0.4,0.5,0.3', 101.4, 23.5, 49.0, 60.0, 6.2, 178.0, 62.0),
    
    -- Readings for SES024
    ('USR008', 'SES024', '2024-10-05 18:00:00', 'Lower Back', 3.8, 90.0, 9.0, 'Walking', 
     34.1, 7.2, 19.0, 97.8, 58.0, '0.9,0.6,-9.6', '3.0,2.2,1.6', 101.5, 22.0, 40.0, 50.0, 3.5, 82.0, 80.0),
    
    -- Readings for SES025
    ('USR009', 'SES025', '2024-10-02 09:30:00', 'Legs', 5.5, 120.0, 13.5, 'Dancing', 
     34.6, 9.8, 24.0, 97.2, 105.0, '1.8,1.2,-9.4', '6.8,5.2,3.5', 101.8, 22.0, 42.0, 64.0, 4.8, 132.0, 70.0),
    
    -- Readings for SES026
    ('USR009', 'SES026', '2024-10-04 13:15:00', 'Upper Back', 6.5, 69.0, 23.0, 'Sitting', 
     33.6, 10.8, 15.0, 98.6, 76.0, '0.1,0.2,-9.8', '0.3,0.5,0.2', 101.1, 23.5, 48.5, 54.0, 5.5, 158.0, 67.0),
    
    -- Readings for SES027
    ('USR009', 'SES027', '2024-10-07 10:45:00', 'Neck', 6.0, 77.0, 19.0, 'Sitting', 
     33.8, 10.2, 16.5, 98.2, 72.0, '0.2,0.3,-9.8', '0.4,0.6,0.3', 101.3, 23.0, 47.5, 52.0, 5.0, 142.0, 70.0),
    
    -- Readings for SES028
    ('USR010', 'SES028', '2024-10-01 08:30:00', 'Upper Back', 7.5, 135.0, 20.0, 'Climbing', 
     35.2, 12.5, 30.0, 96.5, 155.0, '2.8,2.0,-9.2', '9.5,7.8,5.2', 102.8, 20.0, 36.0, 75.0, 6.8, 198.0, 58.0),
    
    -- Readings for SES029
    ('USR010', 'SES029', '2024-10-03 14:45:00', 'Neck', 7.8, 72.0, 27.5, 'Sitting', 
     33.7, 13.2, 15.5, 98.5, 90.0, '0.1,0.2,-9.8', '0.3,0.4,0.2', 101.2, 24.0, 52.0, 64.0, 7.0, 205.0, 56.0),
    
    -- Readings for SES030
    ('USR010', 'SES030', '2024-10-06 11:30:00', 'Lower Back', 3.0, 66.0, 6.5, 'Stretching', 
     33.4, 4.8, 11.0, 99.0, 38.0, '0.2,0.1,-9.8', '0.6,0.4,0.2', 100.9, 21.5, 43.0, 40.0, 2.5, 52.0, 90.0);
GO

-- =========================
-- VERIFY DATA
-- =========================
SELECT 'Users' AS TableName, COUNT(*) AS RecordCount FROM dbo.Users
UNION ALL
SELECT 'Sessions', COUNT(*) FROM dbo.Sessions
UNION ALL
SELECT 'Readings', COUNT(*) FROM dbo.Readings;
GO