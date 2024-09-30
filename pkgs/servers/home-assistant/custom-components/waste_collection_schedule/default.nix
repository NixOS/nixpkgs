{ lib
, buildHomeAssistantComponent
, fetchFromGitHub
, beautifulsoup4
, icalendar
, icalevents
, lxml
, pycryptodome
, recurring-ical-events
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "waste_collection_schedule";
  version = "2.2.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hacs_${domain}";
    rev = "refs/tags/${version}";
    hash = "sha256-XzHShFM0H8F/erc/XiCMDotCfN/JJoO5SWX+O9Fqxkw=";
  };

  dependencies = [
    beautifulsoup4
    icalendar
    icalevents
    lxml
    pycryptodome
    recurring-ical-events
  ];

  meta = with lib; {
    changelog = "https://github.com/mampfes/hacs_waste_collection_schedule/releases/tag/${version}";
    description = "Home Assistant integration framework for (garbage collection) schedules";
    homepage = "https://github.com/mampfes/hacs_waste_collection_schedule";
    maintainers = with maintainers; [jamiemagee];
    license = licenses.mit;
  };
}
