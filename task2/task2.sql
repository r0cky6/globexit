DECLARE @emp_id INT;
SET @emp_id = 710253;

WITH subdivisions_up AS (
	SELECT 
		[subdivisions].parent_id,
		1 AS "depth"
	FROM [subdivisions]
	WHERE [subdivisions].[id] = (
		SELECT [collaborators].[subdivision_id]
		FROM [collaborators]
		WHERE [collaborators].[id] = @emp_id
	)
	UNION ALL
	SELECT 
		[subdivisions].[parent_id],
		[subdivisions_up].[depth] + 1 AS "depth"
	FROM [subdivisions]
	INNER JOIN [subdivisions_up] ON [subdivisions_up].[parent_id] = [subdivisions].[id]
),
subdivisions_down AS (
	SELECT [subdivisions].*,
	(
		SELECT TOP 1 [subdivisions_up].[depth]
		FROM [subdivisions_up]
		ORDER BY [subdivisions_up].[depth] DESC
	) + 1 AS "depth"
	FROM [subdivisions]
	WHERE [subdivisions].[parent_id] = (
		SELECT [collaborators].[subdivision_id]
		FROM [collaborators]
		WHERE [collaborators].[id] = @emp_id
	)
	UNION ALL
	SELECT 
		[subdivisions].*,
		[subdivisions_down].[depth] + 1 AS "depth"
	FROM [subdivisions_down]
	INNER JOIN [subdivisions] ON [subdivisions].[parent_id] = [subdivisions_down].[id]
)
SELECT 
	[collaborators].[id],
	[collaborators].[name],
	[subdivisions_down].[id] AS "sub_id",
	[subdivisions_down].[name] AS "sub_name",
	[subdivisions_down].[depth] AS "sub_level",
	(
		SELECT COUNT(*)
		FROM [collaborators]
		WHERE [collaborators].[subdivision_id] = [subdivisions_down].[id]
	) AS "colls_count"
FROM [collaborators]
INNER JOIN [subdivisions_down] ON [collaborators].[subdivision_id] = [subdivisions_down].[id]
WHERE 
	[collaborators].[age] < 40
	AND LEN([collaborators].[name]) > 11
	AND [subdivisions_down].[id] NOT IN (100055, 100059)
ORDER BY [sub_level] ASC;