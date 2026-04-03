{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  beautifulsoup4,
  cloudscraper,
  icalendar,
  icalevents,
  lxml,
  pycryptodome,
  pypdf,
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "waste_collection_schedule";
  version = "2.12.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hacs_waste_collection_schedule";
    tag = version;
    hash = "sha256-mR8UCDQDQBMYCxIA8DKLhD+u9utfMx+woS5L2E7mxXM=";
  };

  dependencies = [
    beautifulsoup4
    cloudscraper
    icalendar
    icalevents
    lxml
    pycryptodome
    pypdf
  ];

  meta = {
    changelog = "https://github.com/mampfes/hacs_waste_collection_schedule/releases/tag/${version}";
    description = "Home Assistant integration framework for (garbage collection) schedules";
    homepage = "https://github.com/mampfes/hacs_waste_collection_schedule";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
}
