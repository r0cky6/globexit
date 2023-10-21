DECLARE @emp_id INT;
SET @emp_id = 710253;
-- s
WITH
subdivision AS (
    SELECT TOP 1 [collaborators].[subdivision_id] AS "sub_id" FROM [collaborators] WHERE [id] = @emp_id
),
distance_to_root AS (
    SELECT 
        [parent_id], 
        1 AS "distance" 
    FROM [subdivisions]
    WHERE id = (SELECT [sub_id] FROM [subdivision])
    UNION ALL
    SELECT 
        [subdivisions].[parent_id], 
        [distance_to_root].[distance] + 1 
    FROM [distance_to_root]
    JOIN [subdivisions] 
    ON [distance_to_root].[parent_id] = [subdivisions].[id]
),
subdivisions_down AS (
    SELECT 
        [subs].[id] AS "sub_id", 
        [subs].[parent_id], 
        [subs].[name] AS "sub_name", 
    (
        SELECT TOP 1 [distance] + 1
        FROM [distance_to_root] 
        ORDER BY [distance] DESC
    ) AS [sub_level]
    FROM [subdivisions] [subs]
    WHERE [subs].[parent_id] = (SELECT [sub_id] FROM [subdivision])
    UNION ALL
    SELECT 
        [subs].[id], 
        [subs].[parent_id], 
        [subs].[name], 
        [subdivisions_down].[sub_level] + 1 
    FROM [subdivisions_down]
    JOIN [subdivisions] [subs]
    ON [subdivisions_down].[sub_id] = [subs].[parent_id]
),
collaborators_count AS (
    SELECT [collaborators].[id],
    (
        SELECT COUNT([collaborators].[id]) 
        FROM [collaborators] 
        WHERE [collaborators].[subdivision_id] = [subdivisions_down].[sub_id]
    ) AS "colls_count"
    FROM [collaborators] 
    JOIN [subdivisions_down] 
    ON [subdivisions_down].[sub_id]= [collaborators].[subdivision_id]
)
SELECT 
    [collaborators].[id],
    [collaborators].[name],
    [subdivisions_down].[sub_id],
    [subdivisions_down].[sub_name],
    [subdivisions_down].[sub_level],
    [collaborators_count].[colls_count]
FROM [subdivisions_down]
JOIN [collaborators] 
ON [collaborators].[subdivision_id] = [subdivisions_down].[sub_id]
JOIN [collaborators_count] 
ON [collaborators_count].[id] = [collaborators].[id]
WHERE [collaborators].[age] < 40
AND LEN([collaborators].[name]) > 11
AND [subdivisions_down].[sub_id] NOT IN (100055, 100059)
ORDER BY [sub_level] ASC;
