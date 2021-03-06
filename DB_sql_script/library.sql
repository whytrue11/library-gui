USE [master]
GO
/****** Object:  Database [library]   ******/
CREATE DATABASE [library]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'library', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\library.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'library_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\library_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [library] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [library].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [library] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [library] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [library] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [library] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [library] SET ARITHABORT OFF 
GO
ALTER DATABASE [library] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [library] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [library] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [library] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [library] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [library] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [library] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [library] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [library] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [library] SET  DISABLE_BROKER 
GO
ALTER DATABASE [library] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [library] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [library] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [library] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [library] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [library] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [library] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [library] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [library] SET  MULTI_USER 
GO
ALTER DATABASE [library] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [library] SET DB_CHAINING OFF 
GO
ALTER DATABASE [library] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [library] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [library] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [library] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [library] SET QUERY_STORE = OFF
GO
USE [library]
GO
/****** Object:  User [test]     ******/
CREATE USER [test] FOR LOGIN [test] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[BookCard]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookCard](
	[IdBookCard] [int] IDENTITY(1,1) NOT NULL,
	[ReaderId] [int] NOT NULL,
	[BookId] [int] NOT NULL,
	[IssueDate] [date] NOT NULL,
	[ReturnDate] [date] NULL,
	[Lost] [bit] NOT NULL,
 CONSTRAINT [PK_CardBook] PRIMARY KEY CLUSTERED 
(
	[IdBookCard] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reader]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reader](
	[IdReader] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[FIO] [varchar](128) NOT NULL,
	[Phone] [varchar](15) NOT NULL,
	[Email] [varchar](128) NOT NULL,
 CONSTRAINT [PK_Reader] PRIMARY KEY CLUSTERED 
(
	[IdReader] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[IdUser] [int] IDENTITY(1,1) NOT NULL,
	[Login] [varchar](128) NOT NULL,
	[Password] [varchar](128) NOT NULL,
	[Blocked] [bit] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[IdUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Debtors]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Debtors] AS
	SELECT IdReader, UserId, FIO, Phone, Email, Blocked 
		FROM Reader
		JOIN BookCard ON IdReader = ReaderId AND ReturnDate IS NULL
		JOIN "User" ON "User".IdUser = Reader.UserId
GO
/****** Object:  Table [dbo].[Book]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[IdBook] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](350) NOT NULL,
	[ReleaseDate] [date] NULL,
	[AuthorFIO] [varchar](128) NOT NULL,
	[NumberOfPage] [int] NOT NULL,
	[Description] [varchar](1000) NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED 
(
	[IdBook] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BookTop]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BookTop] AS
	SELECT TOP 100 IdBook, Book.Name, ReleaseDate, AuthorFIO, NumberOfPage, Description 
	FROM BookCard 
	JOIN Book ON BookCard.BookId = IdBook
	GROUP BY IdBook, Book.Name, ReleaseDate, AuthorFIO, NumberOfPage, Description
	ORDER BY COUNT(*)
GO
/****** Object:  Table [dbo].[Post]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Post](
	[IdPost] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED 
(
	[IdPost] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[IdEmployee] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[FIO] [varchar](128) NOT NULL,
	[Phone] [varchar](15) NOT NULL,
	[Email] [varchar](128) NOT NULL,
	[PostId] [int] NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[IdEmployee] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[EmployeeData]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EmployeeData] AS
	SELECT IdEmployee, FIO, Phone, Email, Name 
	FROM Employee 
	JOIN Post ON PostId = IdPost
GO
/****** Object:  Table [dbo].[BookGenres]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookGenres](
	[IdBookGenres] [int] IDENTITY(1,1) NOT NULL,
	[BookId] [int] NOT NULL,
	[GenreId] [int] NOT NULL,
 CONSTRAINT [PK_BookGenres] PRIMARY KEY CLUSTERED 
(
	[IdBookGenres] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Genre]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genre](
	[IdGenre] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED 
(
	[IdGenre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Book] ON 

INSERT [dbo].[Book] ([IdBook], [Name], [ReleaseDate], [AuthorFIO], [NumberOfPage], [Description], [Quantity]) VALUES (4, N'Мы', CAST(N'1924-01-01' AS Date), N'Евгений Замятин', 224, N'Знаковый роман, с которого официально отсчитывают само существование жанра "антиутопия" Запрещенный в советский период,
теперь он считается одним из классических произведений не только русской, но и мировой литературы ХХ века. Роман об "обществе равных",
в котором человеческая личность сведена к "нумеру". В нем унифицировано все — одежда и квартиры, мысли и чувства. Нет ни семьи, ни прочных привязанностей...', 4)
INSERT [dbo].[Book] ([IdBook], [Name], [ReleaseDate], [AuthorFIO], [NumberOfPage], [Description], [Quantity]) VALUES (9, N'Война и мир I', CAST(N'1867-01-01' AS Date), N'Толстой Л.Н.', 1000, NULL, 6)
INSERT [dbo].[Book] ([IdBook], [Name], [ReleaseDate], [AuthorFIO], [NumberOfPage], [Description], [Quantity]) VALUES (10, N'Война и мир II ТОМ', CAST(N'1867-01-01' AS Date), N'Толстой Л.Н.', 1000, N' ', 2)
INSERT [dbo].[Book] ([IdBook], [Name], [ReleaseDate], [AuthorFIO], [NumberOfPage], [Description], [Quantity]) VALUES (11, N'Обломов', CAST(N'1859-01-01' AS Date), N'Гончаров И.А.', 413, NULL, 3)
INSERT [dbo].[Book] ([IdBook], [Name], [ReleaseDate], [AuthorFIO], [NumberOfPage], [Description], [Quantity]) VALUES (13, N'Преступление и наказание', CAST(N'1866-01-01' AS Date), N'Достоевский Ф.М.', 567, NULL, 5)
INSERT [dbo].[Book] ([IdBook], [Name], [ReleaseDate], [AuthorFIO], [NumberOfPage], [Description], [Quantity]) VALUES (16, N'Остров сокровищ', CAST(N'1883-11-14' AS Date), N'Стивенсон Р.Л.', 367, NULL, 9)
INSERT [dbo].[Book] ([IdBook], [Name], [ReleaseDate], [AuthorFIO], [NumberOfPage], [Description], [Quantity]) VALUES (17, N'Унесённые ветром', CAST(N'1936-05-30' AS Date), N'Митчел М', 623, NULL, 11)
SET IDENTITY_INSERT [dbo].[Book] OFF
GO
SET IDENTITY_INSERT [dbo].[BookCard] ON 

INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (1, 1, 4, CAST(N'2021-12-03' AS Date), CAST(N'2021-12-03' AS Date), 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (2, 1, 4, CAST(N'2021-12-03' AS Date), CAST(N'2021-12-03' AS Date), 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (3, 18, 4, CAST(N'2021-12-03' AS Date), NULL, 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (5, 25, 4, CAST(N'2021-12-24' AS Date), NULL, 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (6, 25, 9, CAST(N'2021-12-24' AS Date), CAST(N'2021-12-24' AS Date), 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (7, 25, 10, CAST(N'2021-12-24' AS Date), CAST(N'2021-12-24' AS Date), 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (8, 26, 4, CAST(N'2021-12-24' AS Date), CAST(N'2021-12-24' AS Date), 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (9, 26, 17, CAST(N'2021-12-24' AS Date), CAST(N'2021-12-24' AS Date), 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (10, 26, 13, CAST(N'2021-12-24' AS Date), CAST(N'2021-12-24' AS Date), 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (11, 26, 16, CAST(N'2021-12-24' AS Date), NULL, 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (12, 26, 11, CAST(N'2021-12-24' AS Date), CAST(N'2021-12-24' AS Date), 0)
INSERT [dbo].[BookCard] ([IdBookCard], [ReaderId], [BookId], [IssueDate], [ReturnDate], [Lost]) VALUES (13, 26, 17, CAST(N'2021-12-24' AS Date), NULL, 0)
SET IDENTITY_INSERT [dbo].[BookCard] OFF
GO
SET IDENTITY_INSERT [dbo].[BookGenres] ON 

INSERT [dbo].[BookGenres] ([IdBookGenres], [BookId], [GenreId]) VALUES (3, 4, 1)
INSERT [dbo].[BookGenres] ([IdBookGenres], [BookId], [GenreId]) VALUES (5, 4, 2)
INSERT [dbo].[BookGenres] ([IdBookGenres], [BookId], [GenreId]) VALUES (10, 9, 1)
INSERT [dbo].[BookGenres] ([IdBookGenres], [BookId], [GenreId]) VALUES (11, 10, 1)
INSERT [dbo].[BookGenres] ([IdBookGenres], [BookId], [GenreId]) VALUES (13, 17, 1)
SET IDENTITY_INSERT [dbo].[BookGenres] OFF
GO
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([IdEmployee], [UserId], [FIO], [Phone], [Email], [PostId]) VALUES (1, 1, N'Director Directovich', N'88005553535', N'director@pochta.ru', 2)
INSERT [dbo].[Employee] ([IdEmployee], [UserId], [FIO], [Phone], [Email], [PostId]) VALUES (3, 24, N'Librarian Librarian', N'84440003230', N'librarian@pochta.ru', 3)
INSERT [dbo].[Employee] ([IdEmployee], [UserId], [FIO], [Phone], [Email], [PostId]) VALUES (4, 33, N'fio', N'1234', N'mail', 3)
INSERT [dbo].[Employee] ([IdEmployee], [UserId], [FIO], [Phone], [Email], [PostId]) VALUES (5, 41, N'test', N'test phone', N'test mail', 2)
SET IDENTITY_INSERT [dbo].[Employee] OFF
GO
SET IDENTITY_INSERT [dbo].[Genre] ON 

INSERT [dbo].[Genre] ([IdGenre], [Name]) VALUES (1, N'Romance')
INSERT [dbo].[Genre] ([IdGenre], [Name]) VALUES (2, N'Fairy tale')
INSERT [dbo].[Genre] ([IdGenre], [Name]) VALUES (4, N'Fantastic')
INSERT [dbo].[Genre] ([IdGenre], [Name]) VALUES (5, N'Comedy')
INSERT [dbo].[Genre] ([IdGenre], [Name]) VALUES (6, N'Drama')
INSERT [dbo].[Genre] ([IdGenre], [Name]) VALUES (7, N'My1')
SET IDENTITY_INSERT [dbo].[Genre] OFF
GO
SET IDENTITY_INSERT [dbo].[Post] ON 

INSERT [dbo].[Post] ([IdPost], [Name]) VALUES (2, N'Director')
INSERT [dbo].[Post] ([IdPost], [Name]) VALUES (3, N'Librarian')
INSERT [dbo].[Post] ([IdPost], [Name]) VALUES (4, N'MyRole')
SET IDENTITY_INSERT [dbo].[Post] OFF
GO
SET IDENTITY_INSERT [dbo].[Reader] ON 

INSERT [dbo].[Reader] ([IdReader], [UserId], [FIO], [Phone], [Email]) VALUES (1, 2, N'First Reader', N'84440003232', N'reader@pochta.ru')
INSERT [dbo].[Reader] ([IdReader], [UserId], [FIO], [Phone], [Email]) VALUES (18, 23, N'I Love Books', N'84440203232', N'reader2@pochta.ru')
INSERT [dbo].[Reader] ([IdReader], [UserId], [FIO], [Phone], [Email]) VALUES (25, 32, N'test_reader', N'555-333', N'test@pochta.ru')
INSERT [dbo].[Reader] ([IdReader], [UserId], [FIO], [Phone], [Email]) VALUES (26, 34, N'Vasya Pupkin', N'89594356454', N'vasya2006@pochta.ru')
INSERT [dbo].[Reader] ([IdReader], [UserId], [FIO], [Phone], [Email]) VALUES (28, 37, N'awfawf', N'555-3331', N'ffawf')
INSERT [dbo].[Reader] ([IdReader], [UserId], [FIO], [Phone], [Email]) VALUES (29, 43, N'bbb', N'ddd', N'ddd')
INSERT [dbo].[Reader] ([IdReader], [UserId], [FIO], [Phone], [Email]) VALUES (30, 44, N'Daniil Shilov', N'555-555-555', N'shilov@pochta.ru')
SET IDENTITY_INSERT [dbo].[Reader] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (1, N'admin', N'92668751', 0)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (2, N'ilovebooks', N'1509442', 0)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (23, N'reader_2', N'1509442', 0)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (24, N'librarian', N'812757528', 0)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (32, N'test', N'1509442', 1)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (33, N'librarian_2', N'1509442', 0)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (34, N'reader_1', N'1509442', 0)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (37, N'reader_3', N'1509442', 0)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (41, N'aaaaB', N'1509442', 0)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (43, N'test ddd', N'1509442', 0)
INSERT [dbo].[User] ([IdUser], [Login], [Password], [Blocked]) VALUES (44, N'reader', N'1509442', 0)
SET IDENTITY_INSERT [dbo].[User] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Email]     ******/
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Phone]     ******/
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [Phone] UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UserId]     ******/
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [UserId] UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Email_Reader]     ******/
ALTER TABLE [dbo].[Reader] ADD  CONSTRAINT [Email_Reader] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Phone_Reader]     ******/
ALTER TABLE [dbo].[Reader] ADD  CONSTRAINT [Phone_Reader] UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UserId_Reader]     ******/
ALTER TABLE [dbo].[Reader] ADD  CONSTRAINT [UserId_Reader] UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_User]     ******/
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [IX_User] UNIQUE NONCLUSTERED 
(
	[Login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BookCard]  WITH CHECK ADD  CONSTRAINT [FK_BookCard_Book] FOREIGN KEY([BookId])
REFERENCES [dbo].[Book] ([IdBook])
GO
ALTER TABLE [dbo].[BookCard] CHECK CONSTRAINT [FK_BookCard_Book]
GO
ALTER TABLE [dbo].[BookCard]  WITH CHECK ADD  CONSTRAINT [FK_BookCard_Reader] FOREIGN KEY([ReaderId])
REFERENCES [dbo].[Reader] ([IdReader])
GO
ALTER TABLE [dbo].[BookCard] CHECK CONSTRAINT [FK_BookCard_Reader]
GO
ALTER TABLE [dbo].[BookGenres]  WITH CHECK ADD  CONSTRAINT [FK_BookGenres_Book] FOREIGN KEY([BookId])
REFERENCES [dbo].[Book] ([IdBook])
GO
ALTER TABLE [dbo].[BookGenres] CHECK CONSTRAINT [FK_BookGenres_Book]
GO
ALTER TABLE [dbo].[BookGenres]  WITH CHECK ADD  CONSTRAINT [FK_BookGenres_Genre] FOREIGN KEY([GenreId])
REFERENCES [dbo].[Genre] ([IdGenre])
GO
ALTER TABLE [dbo].[BookGenres] CHECK CONSTRAINT [FK_BookGenres_Genre]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Post] FOREIGN KEY([PostId])
REFERENCES [dbo].[Post] ([IdPost])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Post]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([IdUser])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_User]
GO
ALTER TABLE [dbo].[Reader]  WITH CHECK ADD  CONSTRAINT [FK_Reader_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([IdUser])
GO
ALTER TABLE [dbo].[Reader] CHECK CONSTRAINT [FK_Reader_User]
GO
/****** Object:  StoredProcedure [dbo].[AddBook]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddBook] (@Name AS varchar(350), @ReleaseDate AS date, @AuthorFIO AS varchar(128), @NumberOfPage AS int, @Description AS varchar(1000), @Quantity AS int) AS
BEGIN
	IF (SELECT COUNT(*) FROM Book WHERE Name=@Name AND ReleaseDate=@ReleaseDate AND AuthorFIO=@AuthorFIO AND NumberOfPage=@NumberOfPage AND Description=@Description GROUP BY Name, ReleaseDate, AuthorFIO, NumberOfPage, Description)=1
		UPDATE Book
		SET Quantity = Quantity + @Quantity
		WHERE IdBook = (SELECT IdBook FROM Book WHERE Name=@Name AND ReleaseDate=@ReleaseDate AND AuthorFIO=@AuthorFIO AND NumberOfPage=@NumberOfPage AND Description=@Description)
	ELSE
		INSERT INTO Book (Name, ReleaseDate, AuthorFIO, NumberOfPage, Description, Quantity)
		VALUES (@Name, @ReleaseDate, @AuthorFIO, @NumberOfPage, @Description, @Quantity)
END
GO
/****** Object:  StoredProcedure [dbo].[AddGenre]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddGenre] (@BookId AS int, @GenreId AS int) AS
	INSERT INTO BookGenres (BookId, GenreId)
	VALUES (@BookId, @GenreId)
GO
/****** Object:  StoredProcedure [dbo].[AuthorizationUserStatus]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AuthorizationUserStatus] (@Login AS varchar(128), @Password AS varchar(128), @AuthorizationStatus AS int OUTPUT) AS
	IF (SELECT COUNT(*) FROM "User" WHERE "User".Login = @Login AND "User".Password = @Password) = 1
		SET @AuthorizationStatus = 1
	ELSE
		SET @AuthorizationStatus = 0
GO
/****** Object:  StoredProcedure [dbo].[BookTopGenre]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BookTopGenre] (@GenreId AS int) AS
	SELECT BookTop.Name, ReleaseDate, AuthorFIO, NumberOfPage, Description 
	FROM BookTop 
	JOIN BookGenres ON BookGenres.BookId = BookTop.IdBook AND GenreId = @GenreId
GO
/****** Object:  StoredProcedure [dbo].[DebtorsN]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DebtorsN] (@n AS INT) AS
	IF (@n = 0)
		SELECT IdReader, UserId, FIO, Phone, Email, Blocked 
		FROM Reader
		JOIN "User" ON "User".IdUser = Reader.UserId
		EXCEPT
		SELECT IdReader, UserId, FIO, Phone, Email, Blocked
		FROM Reader
		JOIN BookCard ON ReaderId = IdReader
		JOIN "User" ON "User".IdUser = Reader.UserId
	ELSE
		SELECT * FROM Debtors
		GROUP BY IdReader, UserId, FIO, Phone, Email, Blocked
		HAVING Count(*) >= @n
GO
/****** Object:  StoredProcedure [dbo].[DeleteBook]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteBook] (@BookId AS INT, @Status AS int OUTPUT) AS
	IF (SELECT COUNT(*) FROM BookCard WHERE BookId = @BookId) > 0
		BEGIN
		SET @Status = 0
		RETURN
		END

	DELETE FROM BookGenres WHERE BookId = @BookId
	DELETE FROM Book WHERE IdBook = @BookId
	SET @Status = 1
GO
/****** Object:  StoredProcedure [dbo].[DeleteBookGenre]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteBookGenre] (@BookId AS int, @GenreId AS int) AS
	DELETE FROM BookGenres WHERE BookId = @BookId AND GenreId = @GenreId
GO
/****** Object:  StoredProcedure [dbo].[DeleteGenre]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteGenre] (@GenreId AS INT) AS
	DELETE FROM BookGenres WHERE GenreId = @GenreId
	DELETE FROM Genre WHERE IdGenre = @GenreId
GO
/****** Object:  StoredProcedure [dbo].[EmployeeDataId]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EmployeeDataId] (@Id AS INT) AS
	SELECT FIO, Phone, Email, Name
	FROM EmployeeData WHERE IdEmployee = @Id
GO
/****** Object:  StoredProcedure [dbo].[EmployeeRegistration]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EmployeeRegistration] (@Login AS varchar(128), @Password AS varchar(128), @FIO AS varchar(128), @Phone AS varchar(15), @Email AS varchar(128), @PostId AS INT) AS
BEGIN
	BEGIN TRY
		INSERT INTO "User" (Login, Password, Blocked)
		VALUES (@Login, @Password, 0)
	END TRY
	BEGIN CATCH
		RETURN
	END CATCH

	BEGIN TRY
		INSERT INTO Employee (UserId, FIO, Phone, Email, PostId)
		VALUES (SCOPE_IDENTITY(), @FIO, @Phone, @Email, @PostId)
	END TRY
	BEGIN CATCH
		DELETE FROM "User" WHERE IdUser = SCOPE_IDENTITY()
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[IssueBook]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IssueBook] (@ReaderId AS int, @BookId AS int) AS
BEGIN
	IF (SELECT Quantity FROM Book WHERE IdBook = @BookId) > 0
	BEGIN
		BEGIN TRY
			INSERT INTO BookCard (ReaderId, BookId, IssueDate, ReturnDate, Lost)
			VALUES (@ReaderId, @BookId, GETDATE(), NULL, 0)
		END TRY
		BEGIN CATCH
			RETURN
		END CATCH

		UPDATE Book
		SET Quantity = Quantity - 1
		WHERE IdBook = @BookId
	END
END
GO
/****** Object:  StoredProcedure [dbo].[ReaderDataId]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReaderDataId] (@Id AS INT) AS
	SELECT FIO, Phone, Email 
	FROM Reader
	WHERE IdReader = @Id
GO
/****** Object:  StoredProcedure [dbo].[ReaderRegistration]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReaderRegistration] (@Login AS varchar(128), @Password AS varchar(128), @FIO AS varchar(128), @Phone AS varchar(15), @Email AS varchar(128), @UserId AS int OUTPUT) AS
BEGIN
	BEGIN TRY
		INSERT INTO "User" (Login, Password, Blocked)
		VALUES (@Login, @Password, 0)
	END TRY
	BEGIN CATCH
		SET @UserId = -1
		RETURN
	END CATCH

	BEGIN TRY
		INSERT INTO Reader (UserId, FIO, Phone, Email)
		VALUES (SCOPE_IDENTITY(), @FIO, @Phone, @Email)
		SET @UserId = SCOPE_IDENTITY()
	END TRY
	BEGIN CATCH
		DELETE FROM "User" WHERE IdUser = SCOPE_IDENTITY()
		SET @UserId = -1
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[ReturnBook]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReturnBook] (@BookCardId AS int) AS
BEGIN
	IF (SELECT ReturnDate FROM BookCard WHERE IdBookCard = @BookCardId) IS NOT NULL
		RETURN

	BEGIN TRY
		UPDATE BookCard
		SET ReturnDate = GETDATE(), Lost = 0
		WHERE IdBookCard = @BookCardId
	END TRY
	BEGIN CATCH
		RETURN
	END CATCH

	UPDATE Book
	SET Quantity = Quantity + 1
	WHERE IdBook = (SELECT BookId FROM BookCard WHERE IdBookCard = @BookCardId)
END
GO
/****** Object:  StoredProcedure [dbo].[UnreturnedBooks]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UnreturnedBooks] (@ReaderId AS int) AS
	SELECT IdBook, Book.Name, ReleaseDate, AuthorFIO, NumberOfPage, Description 
	FROM Book
	JOIN BookCard ON BookId = IdBook AND ReaderId = @ReaderId AND ReturnDate IS NULL
GO
/****** Object:  StoredProcedure [dbo].[UserStatus]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserStatus] (@Login AS varchar(128), @Password AS varchar(128), @Status AS int OUTPUT) AS
	IF (SELECT COUNT(*) FROM "User" WHERE "User".Login = @Login AND "User".Password = @Password) = 1
		BEGIN
			DECLARE @UserId int
			SET @UserId = (SELECT IdUser FROM "User" WHERE "User".Login = @Login)

			IF (SELECT COUNT(*) FROM Reader WHERE Reader.UserId = @UserId) = 1
				BEGIN
					SET @Status = 0
					RETURN
				END
			ELSE IF (SELECT PostId FROM Employee JOIN Post ON Post.IdPost = Employee.PostId WHERE Employee.UserId = @UserId) = (SELECT IdPost FROM Post WHERE Name = 'Librarian')
				BEGIN
					SET @Status = 1
					RETURN
				END
			SET @Status = 2
		END
GO
USE [master]
GO
ALTER DATABASE [library] SET  READ_WRITE 
GO
