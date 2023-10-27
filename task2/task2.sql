DECLARE @emp_id INT;
SET @emp_id = 710253;

WITH 
subdivisions_branch AS (
	SELECT 
		[subdivisions].[id],
		[subdivisions].[parent_id],
		[subdivisions].[id] AS "branch",
		0 AS "row",
		1 as "is_heading_down"
	FROM [subdivisions]
	WHERE [subdivisions].[parent_id] = (
		SELECT [collaborators].[subdivision_id]
		FROM [collaborators]
		WHERE [collaborators].[id] = @emp_id
	)
	UNION ALL
	SELECT 
		[subdivisions].[id],
		[subdivisions].[parent_id],
		[subdivisions_branch].[id] AS "branch",
		CASE WHEN 
			[subdivisions].[parent_id] = [subdivisions_branch].[id] 
			THEN [subdivisions_branch].[row] + 1 
			ELSE [subdivisions_branch].[row] - 1 
			END AS "row",
		CASE WHEN 
			[subdivisions].[parent_id] = [subdivisions_branch].[id] 
			AND [subdivisions_branch].[is_heading_down] = 1
			THEN 1 
			ELSE 0 
			END as "is_heading_down"
	FROM [subdivisions]
	JOIN [subdivisions_branch] 
		ON (
			(
				[subdivisions].[id] = [subdivisions_branch].[parent_id]
				AND [subdivisions_branch].[row] < 1
			)
			OR 
			(
				[subdivisions].[parent_id] = [subdivisions_branch].[id]
				AND [subdivisions_branch].[is_heading_down] = 1
			)
		)
)
SELECT 
	[collaborators].[id],
	[collaborators].[name],
	[subdivisions_branch].[id] AS "sub_id", 
	[subdivisions].[name] AS "sub_name",
	[subdivisions_branch].[row] + 1 + ABS((
		SELECT TOP 1 [subdivisions_branch].[row] 
		FROM [subdivisions_branch] 
		ORDER BY [row] ASC
	)) AS "sub_level",
	(
		SELECT COUNT(*)
		FROM [collaborators]
		WHERE [collaborators].[subdivision_id] = [subdivisions_branch].[id]
	) AS "colls_count"
	FROM [subdivisions_branch] 
	JOIN [subdivisions] 
		ON [subdivisions_branch].[id] = [subdivisions].[id] 
	JOIN [collaborators] 
		ON [subdivisions_branch].[id] = [collaborators].[subdivision_id]
	WHERE
		[is_heading_down] = 1 
		AND [collaborators].[age] < 40
		AND LEN([collaborators].[name]) > 11
		AND [subdivisions_branch].[id] NOT IN (100055, 100059)
	ORDER BY [sub_level] ASC;