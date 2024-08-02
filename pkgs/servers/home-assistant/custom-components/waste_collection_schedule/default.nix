{ lib
, buildHomeAssistantComponent
, fetchFromGitHub
, beautifulsoup4
, icalendar
, icalevents
, lxml
, recurring-ical-events
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "waste_collection_schedule";
  version = "2.0.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hacs_${domain}";
    rev = "refs/tags/${version}";
    hash = "sha256-nStfENwlPXPEvK13e8kUpPav6ul6XQO/rViHRHlZpKI=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    icalendar
    icalevents
    lxml
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
