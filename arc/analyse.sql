USE tempdb

/*

truncate table [dbo].[ProcessMonitor0201Pub]

INSERT	INTO [tempdb].[dbo].[ProcessMonitor0201Pub] ([TimeOfDelay], [ProcessName], [PID], [Operation], [Path], [Result], [Detail])
SELECT	TimeOfDelay = ["Time of Day"]
		, ProcessName = ["Process Name"]
		, PID = ["PID"]
		, Operation = ["Operation"]
		, Path = ["Path"]
		, Result = ["Result"]
		, Detail = ["Detail"]
FROM	[dbo].[capture_pub]
*/

-- TOP 5 per minute

;  WITH Process  
AS (
	SELECT	TraceNumber = IIF(LEFT([TimeOfDelay], 2) < 13, 'Trace 1', 'Trace 2')
			, ShortTimeOfDelay = LEFT([TimeOfDelay],5)
			, ProcessName
			, CountOccurence = COUNT(*)
			, RankCountOccurencePerMinute = ROW_NUMBER()OVER( PARTITION BY LEFT([TimeOfDelay],5) ORDER BY COUNT(*) DESC )

	FROM	[tempdb].[dbo].[ProcessMonitor0201Pub]
	WHERE	1 = 1
	--AND		REPLACE(LEFT([TimeOfDelay],5), ':', '') BETWEEN 1100 AND 1130
	AND		ProcessName NOT IN ('Procmon64.exe', 'Explorer.EXE', 'DesktopInfo.exe', 'svchost.exe', 'System', 'wmiprvse.exe', 'services.exe')
	--AND		ProcessName IN ('kavfs.exe')
	GROUP BY IIF(LEFT([TimeOfDelay], 2) < 13, 'Trace 1', 'Trace 2'), LEFT([TimeOfDelay],5), ProcessName
)
SELECT	*
FROM	Process
WHERE	RankCountOccurencePerMinute <= 5
ORDER BY ShortTimeOfDelay ASC, RankCountOccurencePerMinute

-----------

-- TOP 5 overall 

;  WITH Process  
AS (
	SELECT	TraceNumber = IIF(LEFT([TimeOfDelay], 2) < 13, 'Trace 1', 'Trace 2')
			, ShortTimeOfDelay = LEFT([TimeOfDelay],5)
			, ProcessName
			, CountOccurence = COUNT(*)
			, RankCountOccurencePerMinute = ROW_NUMBER()OVER( PARTITION BY LEFT([TimeOfDelay],5) ORDER BY COUNT(*) DESC )

	FROM	[tempdb].[dbo].[ProcessMonitor0201Pub]
	WHERE	1 = 1
	--AND		REPLACE(LEFT([TimeOfDelay],5), ':', '') BETWEEN 1100 AND 1130
	AND		ProcessName NOT IN ('Procmon64.exe', 'Explorer.EXE', 'DesktopInfo.exe', 'svchost.exe', 'System', 'wmiprvse.exe', 'services.exe')
	--AND		ProcessName IN ('kavfs.exe')
	GROUP BY IIF(LEFT([TimeOfDelay], 2) < 13, 'Trace 1', 'Trace 2'), LEFT([TimeOfDelay],5), ProcessName
)
SELECT	*
FROM	Process
WHERE	RankCountOccurencePerMinute <= 1
ORDER BY ShortTimeOfDelay ASC, RankCountOccurencePerMinute

-----------
-- Detail 

/*
SELECT	*
FROM	[dbo].[ProcessMonitor0201Pub]
WHERE	1 = 1
AND		ProcessName = 'svchost.exe'
AND		REPLACE(LEFT([TimeOfDelay],5), ':', '') >= 1100

SELECT	Operation, COUNT(*)
FROM	[dbo].[ProcessMonitor0201Pub]
WHERE	1 = 1
AND		ProcessName = 'kavfs.exe'
AND		REPLACE(LEFT([TimeOfDelay],5), ':', '') >= 1100
group by Operation
ORDER BY COUNT(*) desc

SELECT ShortTimeOfDelay = LEFT([TimeOfDelay],5)
		, *
FROM	[tempdb].[dbo].[ProcessMonitor0201Pub]
WHERE	1 = 1
AND		ProcessName IN ('svchost.exe')
AND		REPLACE(LEFT([TimeOfDelay],5), ':', '') BETWEEN 1100 AND 1130
ORDER BY [TimeOfDelay]


SELECT  ProcessName, Operation, CountOccurence = COUNT(*)
FROM	[tempdb].[dbo].[ProcessMonitor0201Pub]
WHERE	1 = 1
AND		ProcessName IN ('svchost.exe')
AND		REPLACE(LEFT([TimeOfDelay],5), ':', '') BETWEEN 1100 AND 1130
GROUP BY ProcessName, Operation
ORDER BY COUNT(*) desc


*/