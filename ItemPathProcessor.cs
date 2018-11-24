 public class ItemPathProcessor : InteractionAggregationPipelineProcessor
  {
    private const string LongId = "LongId";
    private const string TemplateId = "TemplateId";
    private const string PageEventDefinition = Constants.PageViewEventId;

    protected override void OnProcess(InteractionAggregationPipelineArgs args)
    {
      Assert.ArgumentNotNull(args, nameof(args));

      Log.Debug("#### ItemPathProcessor started", this);

      var events = args.Context?.Interaction?.Events;
      if (events == null || !events.Any())
      {
        return;
      }
      List<Guid> pages = new List<Guid>();

      //VisitData visitData = Sitecore.ContentTesting.Analytics.VisitDataMapper.GetVisitData(args);

      //if (visitData.Pages == null || 0 >= visitData.Pages.Count)
      //    return;
      ItemPaths dimension = args.Context.Results.GetDimension<ItemPaths>();
      PageItemPaths fact = args.Context.Results.GetFact<PageItemPaths>();

      foreach (Sitecore.XConnect.Event evt in events.Where(e => e.DefinitionId == Guid.Parse(PageEventDefinition)))
      {
        var longId = string.Empty;
        var templateId = string.Empty;

        if (evt.CustomValues.Any())
        {
          if (evt.CustomValues.ContainsKey(LongId))
          {
            longId = evt.CustomValues[LongId];
            Log.Debug("#### ItemPathProcessor longId: " + longId, this);
          }
          if (evt.CustomValues.ContainsKey(TemplateId))
          {
            templateId = evt.CustomValues[TemplateId];
            Log.Debug("#### ItemPathProcessor templateId: " + templateId, this);
          }
        }

        if (!string.IsNullOrWhiteSpace(longId) || !string.IsNullOrWhiteSpace(templateId))
        {
          var itemId = dimension.Add(evt.ItemId, longId, templateId);
          ItemPathFactKey pageViewsKey = GetItemPathFactKey(args, itemId);
          ItemPathValue pageViewsValue = GetItemPathValue(evt.EngagementValue, pages, itemId);
          fact.Emit(pageViewsKey, pageViewsValue);
          pages.Add(evt.ItemId);
          Log.Debug("#### ItemPathProcessor added page: " + evt.ItemId, this);
        }
      }
    }

    private static ItemPathValue GetItemPathValue(int value, List<Guid> pages, Guid itemId)
    {
      return new ItemPathValue
      {
        Visits = pages.Contains(itemId) ? 0 : 1,
        Value = pages.Contains(itemId) ? 0 : value
      };
    }

    private static ItemPathFactKey GetItemPathFactKey(InteractionAggregationPipelineArgs args, Guid itemId)
    {
      var pageViewsKey = new ItemPathFactKey(itemId)
      {
        Date = args.DateTimeStrategy.Translate(args.Context.Interaction.StartDateTime)
      };
      return pageViewsKey;
    }
  }
