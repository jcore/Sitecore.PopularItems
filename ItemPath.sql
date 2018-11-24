CREATE TABLE [dbo].[ItemPaths] (
		[ItemId] UNIQUEIDENTIFIER            NOT NULL,
        [ItemPath]   NVARCHAR (1000) NOT NULL,
		[TemplateId]   NVARCHAR(255) NOT NULL,
		CONSTRAINT [PK_UserAgentNames] PRIMARY KEY CLUSTERED ([ItemId] ASC)
);

GO

CREATE TABLE [dbo].[Fact_PageItemPaths] (
        [Date]            SMALLDATETIME    NOT NULL,
		[ItemId] UNIQUEIDENTIFIER            NOT NULL,
        [Visits]          BIGINT           NOT NULL,
        [Value]           BIGINT           NOT NULL,
        CONSTRAINT [FK_Fact_PageItemPath_ItemPath] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[ItemPaths] ([ItemId]),
);


GO
ALTER TABLE [dbo].[Fact_PageItemPaths] NOCHECK CONSTRAINT [FK_Fact_PageItemPath_ItemPath];


GO
CREATE NONCLUSTERED INDEX [IX_ByDateAndItemPath]
        ON [dbo].[Fact_PageItemPaths]([Date] ASC, [ItemId] ASC)
        INCLUDE([Visits], [Value]);


GO

CREATE NONCLUSTERED INDEX [IX_Fact_PageItemPath_ItemPath]
        ON [dbo].[Fact_PageItemPaths]([ItemId] ASC);

GO

CREATE VIEW [dbo].[PageViewsWithPath]
AS
SELECT        TOP (100) PERCENT dbo.Fact_PageItemPaths.ItemId, SUM(dbo.Fact_PageViews.Visits) AS Visits, dbo.ItemPaths.ItemPath, dbo.ItemPaths.TemplateId, dbo.Fact_PageViews.Date
FROM            dbo.Fact_PageItemPaths INNER JOIN
                         dbo.ItemPaths ON dbo.Fact_PageItemPaths.ItemId = dbo.ItemPaths.ItemId INNER JOIN
                         dbo.Fact_PageViews ON dbo.Fact_PageItemPaths.Date = dbo.Fact_PageViews.Date
GROUP BY dbo.Fact_PageItemPaths.ItemId, dbo.ItemPaths.ItemPath, dbo.ItemPaths.TemplateId, dbo.Fact_PageViews.Date

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Fact_PageItemPaths"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ItemPaths"
            Begin Extent = 
               Top = 195
               Left = 467
               Bottom = 308
               Right = 637
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Fact_PageViews"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 136
               Right = 635
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PageViewsWithPath'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PageViewsWithPath'
GO

