{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  click,
  click-default-group,
  python-dateutil,
  sqlite-fts4,
  tabulate,
  pluggy,
  pytestCheckHook,
  hypothesis,
  testers,
  sqlite-utils,
  setuptools,
}:
buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.37";
  pyproject = true;

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sqlite_utils";
    hash = "sha256-VCpxAz1OeTb+kJIwrJeU0+IAAhg4q2Pbrzzo9bwic6Q=";
  };

  dependencies = [
    click
    click-default-group
    python-dateutil
    sqlite-fts4
    tabulate
    pluggy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "sqlite_utils" ];

  passthru.tests.version = testers.testVersion { package = sqlite-utils; };

  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    mainProgram = "sqlite-utils";
    homepage = "https://github.com/simonw/sqlite-utils";
    changelog = "https://github.com/simonw/sqlite-utils/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      meatcar
      techknowlogick
    ];
  };
}
