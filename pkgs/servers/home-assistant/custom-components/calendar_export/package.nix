{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  icalendar,
}:

buildHomeAssistantComponent {
  owner = "JosephAbbey";
  domain = "calendar_export";
  version = "0.1.0-unstable-2025-12-13";

  src = fetchFromGitHub {
    owner = "JosephAbbey";
    repo = "ha_calendar_export";
    rev = "abe73d46a42aaec11aca19fed7913ceb525ca784";
    hash = "sha256-x1UXjpFXKU06FDPLbpPx39nwr1o3ZuluWuSNKomS8SU=";
  };

  dependencies = [ icalendar ];

  ignoreVersionRequirement = [ "icalendar" ];

  meta = {
    description = "Export calendar events in the iCalendar format";
    homepage = "https://github.com/JosephAbbey/ha_calendar_export";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
