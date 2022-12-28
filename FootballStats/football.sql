/*
TODO: 1
Създайте база данни "PlayerStats" за статистики на футболисти от един отбор.
*/

DROP DATABASE IF EXISTS PlayerStats;
CREATE DATABASE PlayerStats;
USE PlayerStats;

/*
TODO: 2
*   Създайте таблица "StatTypes" за следените статистики със следната 
*   структура и данни:

        StatCode {G, A, R, Y, OG, IN, OUT} 
*   and 
        Name {Гол, Асистенция, Червен картон, Жълт картон, Автогол, 
        Смяна влиза, Смяна излиза}
*/

CREATE TABLE StatTypes (
    StatCode CHAR(3) NOT NULL,
    Name NVARCHAR(50) NOT NULL,

    PRIMARY KEY (StatCode)
);

INSERT INTO StatTypes (StatCode, Name)
    VALUES 
    ('G'   , 'Гол'          ),
    ('A'   , 'Асистенция'   ),
    ('R'   , 'Червен картон'),
    ('Y'   , 'Жълт картон'  ),
    ('OG'  , 'Автогол'      ),
    ('IN'  , 'Смяна влиза'  ),
    ('OUT' , 'Смяна излиза' )
;

/*
TODO: 3
*   Създайте таблица "Positions" с позициите на играчите със следната структура и
*   данни:

        PositionCode {GK, RB, LB, CB, RM, LM, CM, CF} 
*   and 
        Name {Вратар, Десен защитник, Ляв защитник, Централен защитник, 
        Десен полузащитник, Ляв полузащитник, Полузащитник, 
        Централен нападател}
*/

CREATE TABLE Positions (
    PositionCode CHAR(2) NOT NULL,
    Name NVARCHAR(50) NOT NULL,

    PRIMARY KEY (PositionCode)
);

INSERT INTO Positions (PositionCode, Name)
    VALUES 
    ('GK' , 'Вратар'             ),
    ('RB' , 'Десен защитник'     ),
    ('LB' , 'Ляв защитник'       ),
    ('CB' , 'Централен защитник' ),
    ('RM' , 'Десен полузащитник' ),
    ('LM' , 'Ляв полузащитник'   ),
    ('CM' , 'Полузащитник'       ),
    ('CF' , 'Централен нападател')
; 

/*
TODO: 4
*   Създайте таблица "Players" с играчите в отбора със следната структура и 
*   данни, включително връзки към други таблици:

    Id, Name, Num, PositionCode
*/

CREATE TABLE Players (
    Id INTEGER NOT NULL AUTO_INCREMENT,
    Name NVARCHAR(50) NOT NULL,
    Num INTEGER NOT NULL,
    PositionCode CHAR(2) NOT NULL,

    PRIMARY KEY (Id),
    FOREIGN KEY (PositionCode) REFERENCES Positions(PositionCode)
);

INSERT INTO Players (Name, Num, PositionCode)
    VALUES 
    ('Ivaylo Trifonov'   , 1 , 'GK'),
    ('Valko Trifonov'    , 2 , 'RB'),
    ('Ognyan Yanev'      , 3 , 'LB'),
    ('Zahari Dragomirov' , 4 , 'CB'),
    ('Bozhidar Chilikov' , 5 , 'RM'),
    ('Timotei Zahariev'  , 6 , 'LM'),
    ('Marin Valentinov'  , 7 , 'CM'),
    ('Mitre Cvetkov'     , 8 , 'CF'),
    ('Zlatko Genov'      , 5 , 'RM'),
    ('Matey Goranov'     , 6 , 'LM'),
    ('Sergei Zhivkov'    , 99, 'CM')
;

/*
TODO: 5
*   Създайте таблица "Tournaments" с турнири, в които участва отбора, 
*   със следната структура и данни:

    Id, Name{Шампионска лига, Първа лига, Купа на България, 
    Суперкупа на България}
*/

CREATE TABLE Tournaments (
    Id INTEGER NOT NULL AUTO_INCREMENT,
    Name NVARCHAR(50) NOT NULL,

    PRIMARY KEY (Id)
);

INSERT INTO Tournaments (Name)
    VALUES 
    ('Шампионска лига'      ),
    ('Първа лига'           ),
    ('Купа на България'     ),
    ('Суперкупа на България')
;

/*
TODO: 6
*   Създайте таблица "Matches" с планираните и изиграни мачове на отбора със
*   следната структура и данни, включително връзки към други таблици:

    Id, MatchDate, TournamentId
*/

CREATE TABLE Matches (
    Id INTEGER NOT NULL AUTO_INCREMENT,
    MatchDate DATE NOT NULL,
    TournamentId INTEGER NOT NULL,

    PRIMARY KEY (Id),
    FOREIGN KEY (TournamentId) REFERENCES Tournaments(Id)
);

INSERT INTO Matches (MatchDate, TournamentId)
    VALUES 
    ('2018-04-08' , 2),
    ('2018-04-13' , 2),
    ('2018-04-21' , 2),
    ('2018-04-28' , 2),
    ('2018-05-06' , 2),
    ('2018-05-11' , 2),
    ('2017-09-21' , 3),
    ('2017-10-26' , 3)
;

/* 
TODO: 7
*   Създайте таблица "MatchStats" с настъпилите събития в мача със следната
*   структура и данни, включително връзки към други таблици:

    Id, MatchId, PlayerId, EventMinute, StatCode
*/

CREATE TABLE MatchStats (
    Id INTEGER NOT NULL AUTO_INCREMENT,
    MatchId INTEGER NOT NULL,
    PlayerId INTEGER NOT NULL,
    EventMinute INTEGER NOT NULL,
    StatCode CHAR(2) NOT NULL,

    PRIMARY KEY(Id),
	FOREIGN KEY(MatchId) REFERENCES Matches(Id),
	FOREIGN KEY(PlayerId) REFERENCES Players(Id),
	FOREIGN KEY(StatCode) REFERENCES StatTypes(StatCode)
);

INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode)
    VALUES 
    (8 , 9  , 14 , 'G' ),
    (8 , 8  , 14 , 'A' ),
    (8 , 3  , 43 , 'Y' ),
    (7 , 2  , 28 , 'Y' ),
    (7 , 10 , 45 , 'Y' ),
    (7 , 10 , 65 , 'R' ),
    (1 , 10 , 23 , 'G' ),
    (1 , 9  , 23 , 'A' ),
    (1 , 9  , 43 , 'G' ),
    (2 , 4  , 33 , 'OG'),
    (2 , 9  , 68 , 'G' ),
    (2 , 1  , 68 , 'A' ),
    (3 , 3  , 35 , 'G' ),
    (3 , 4  , 35 , 'A' ),
    (3 , 8  , 55 , 'G' ),
    (3 , 11 , 55 , 'A' ),
    (4 , 3  , 9  , 'G' ),
    (4 , 8  , 9  , 'G' ),
    (4 , 8  , 56 , 'OG'),
    (5 , 8  , 67 , 'G' )
;

/*
TODO: 8
*   Направете заявка за името и номера на фланелката на всички защитници от 
*   отбора (независимо дали са десни, леви или централни защитници).
*/

SELECT Players.Name, Players.Num
FROM Players
WHERE Players.PositionCode LIKE "%B";

/*
Другият начин е:
WHERE Players.PositionCode = "RB" OR Players.PositionCode = "LB" OR Players.PositionCode = "CB";
Но аз съм на мнението, че първият начин е по-добър, защото ако се добави нова позиция, която също е защитник, няма да трябва да се прави промяна в заявката.
*/

/*
TODO: 9
*   Направете заявка за мачовете на отбора през месец април 2018 г. с две 
*   колони: дата на мача и име на турнира, от който е мача.
*/

SELECT Matches.MatchDate, Tournaments.Name
FROM Matches
INNER JOIN Tournaments
ON Matches.TournamentId = Tournaments.Id
WHERE Matches.MatchDate LIKE "2018-04-%";

/*
Другият начин е:
WHERE Matches.MatchDate BETWEEN "2018-04-01" AND "2018-04-30";
*/

/*
TODO: 10
*   Направете заявка за статистиките на играч с номер на фланелката 99 със 
*   следните колони:
        1. Дата на мача
        2. Име на играча
        3. Номер на фланелката на играча
        4. Минута на събитието
        5. Четимият текст за събитието в мача
*/

SELECT Matches.MatchDate, Players.Name, Players.Num,
MatchStats.EventMinute, StatTypes.Name 
FROM Matches
INNER JOIN Players
ON Players.Num = 99
INNER JOIN MatchStats
ON MatchStats.PlayerId = Players.Id
&& MatchStats.MatchId = Matches.Id
INNER JOIN StatTypes
ON MatchStats.StatCode = StatTypes.StatCode;

/*
TODO: 11
*   Направете заявка за общия брой автоголове на отбора
*/

SELECT COUNT(MatchStats.StatCode)
FROM MatchStats
WHERE MatchStats.StatCode = "OG";

/*
TODO: 12
*   Направете заявка за броя на вкараните голове във всеки един мач преди 
*   2018-05-01, в който е вкаран поне 1 гол, със следните колони:
        1. Дата на мача
        2. Брой вкарани голове в този мач
*/

SELECT Matches.MatchDate, COUNT(MatchStats.StatCode)
FROM Matches
INNER JOIN MatchStats
ON MatchStats.MatchId = Matches.Id
WHERE MatchStats.StatCode = "G"
&& Matches.MatchDate < "2018-05-01"
GROUP BY Matches.MatchDate
HAVING COUNT(MatchStats.StatCode) > 0;

/* 
TODO: 13
*   Направете заявка за броя на головете според позицията на играчите със 
*   следните колони:
        1. Позиция в отбора като четим текст
        2. Брой вкарани голове от играчи на тази позиция

!       Забележка: включете всички позиции в резултата, дори да няма вкарани
!       голове от играчи на тези позиции.
*/

SELECT Positions.Name, COUNT(MatchStats.StatCode)
FROM Positions
LEFT JOIN Players
ON Players.PositionCode = Positions.PositionCode
LEFT JOIN MatchStats
ON MatchStats.PlayerId = Players.Id
WHERE MatchStats.StatCode = "G"
GROUP BY Positions.Name;

/*
TODO: 14
*   Направете заявка за общия брой на картоните (жълти и червени) за всеки 
*   играч, който има такива, сортирана по брой картони в низходящ ред, 
*   със следните колони:
        1. Име на играча
        2. Номер на фланелката на играча
        3. Позиция в отбора като четим текст
        4. Брой получени картони
*/

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