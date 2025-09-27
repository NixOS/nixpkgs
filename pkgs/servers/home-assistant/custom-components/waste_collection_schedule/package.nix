{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  beautifulsoup4,
  icalendar,
  icalevents,
  lxml,
  pycryptodome,
  pypdf,
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "waste_collection_schedule";
  version = "2.10.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hacs_waste_collection_schedule";
    tag = version;
    hash = "sha256-qFeo2VE0sgBq4dwOUm26Vkgi+rv/0PsOyQhlVEJ45aE=";
  };

  dependencies = [
    beautifulsoup4
    icalendar
    icalevents
    lxml
    pycryptodome
    pypdf
  ];

  meta = with lib; {
    changelog = "https://github.com/mampfes/hacs_waste_collection_schedule/releases/tag/${version}";
    description = "Home Assistant integration framework for (garbage collection) schedules";
    homepage = "https://github.com/mampfes/hacs_waste_collection_schedule";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
