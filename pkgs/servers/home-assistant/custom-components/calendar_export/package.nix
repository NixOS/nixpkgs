{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  icalendar,
}:

buildHomeAssistantComponent rec {
  owner = "JosephAbbey";
  domain = "calendar_export";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "JosephAbbey";
    repo = "ha_calendar_export";
    tag = "v${version}";
    hash = "sha256-ULnkjnBc0oR1CwA+Mz1RnVamEXOKpgd60xryZMkCQwg=";
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
