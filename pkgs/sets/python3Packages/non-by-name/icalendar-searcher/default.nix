{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  icalendar,
  lib,
  pyicu,
  pytestCheckHook,
  recurring-ical-events,
}:

buildPythonPackage (finalAttrs: {
  pname = "icalendar-searcher";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCalendar";
    repo = "icalendar-searcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FNrc+SQar8vftn2zGtMtQW5Tb9KwELSozt8oO4ogxn0=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    icalendar
    recurring-ical-events
  ];

  optional-dependencies = {
    collation = [ pyicu ];
  };

  pythonImportsCheck = [ "icalendar_searcher" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = {
    changelog = "https://github.com/PyCalendar/icalendar-searcher/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Search, filter and sort iCalendar components";
    homepage = "https://github.com/PyCalendar/icalendar-searcher";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
    teams = [ lib.teams.ngi ];
  };
})
