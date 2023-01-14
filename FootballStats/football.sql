SELECT Players.Name, Players.Num, StatTypes.Name,
COUNT(MatchStats.StatCode) 
FROM Players
LEFT JOIN MatchStats
ON MatchStats.PlayerId = Players.Id 
&& (MatchStats.StatCode = "R" || MatchStats.StatCode = "Y")
LEFT JOIN StatTypes
ON MatchStats.StatCode = StatTypes.StatCode
GROUP BY Players.Name, Players.Num, StatTypes.Name
HAVING COUNT(MatchStats.StatCode) > 0
ORDER BY COUNT(MatchStats.StatCode);