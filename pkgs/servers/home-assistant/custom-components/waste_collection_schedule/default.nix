{ lib
, buildHomeAssistantComponent
, fetchFromGitHub
, fetchpatch
, beautifulsoup4
, icalendar
, icalevents
, lxml
, recurring-ical-events
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "waste_collection_schedule";
  version = "1.44.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hacs_${domain}";
    rev = "refs/tags/${version}";
    hash = "sha256-G1x7HtgdtK+IaPAfxT+7xsDJi5FnXN4Pg3q7T5Xr8lA=";
  };

  patches = [
    # Corrects a dependency on beautifulsoup4
    (fetchpatch {
      url = "https://github.com/mampfes/hacs_waste_collection_schedule/pull/1515.patch";
      hash = "sha256-dvmicKTjolEcCrKRtZfpN0M/9RQCEQkFk+M6E+qCqfQ=";
    })
  ];

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
