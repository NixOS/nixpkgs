{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  beautifulsoup4,
  icalendar,
  icalevents,
  lxml,
  pycryptodome,
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "waste_collection_schedule";
  version = "2.6.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hacs_waste_collection_schedule";
    tag = version;
    hash = "sha256-gfL5Nxe8io7DTya5x8aQ5PhxiH8rb8L3/CA+UqKEDAk=";
  };

  dependencies = [
    beautifulsoup4
    icalendar
    icalevents
    lxml
    pycryptodome
  ];

  meta = with lib; {
    changelog = "https://github.com/mampfes/hacs_waste_collection_schedule/releases/tag/${version}";
    description = "Home Assistant integration framework for (garbage collection) schedules";
    homepage = "https://github.com/mampfes/hacs_waste_collection_schedule";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
