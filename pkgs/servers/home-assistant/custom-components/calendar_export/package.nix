{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  icalendar,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "JosephAbbey";
  domain = "calendar_export";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "JosephAbbey";
    repo = "ha_calendar_export";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7cz9G6/oVRTMA4UhEftC1NEvHhEjHwv1drIu6lkmCOs=";
  };

  dependencies = [ icalendar ];

  ignoreVersionRequirement = [ "icalendar" ];

  meta = {
    changelog = "https://github.com/josephabbey/ha_calendar_export/releases/tag/${finalAttrs.src.tag}";
    description = "Export calendar events in the iCalendar format";
    homepage = "https://github.com/JosephAbbey/ha_calendar_export";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
