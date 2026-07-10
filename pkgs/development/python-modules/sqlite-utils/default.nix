{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  click-default-group,
  python-dateutil,
  sqlite-fts4,
  tabulate,
  pip,
  pluggy,
  pytestCheckHook,
  hypothesis,
  testers,
  sqlite-utils,
  setuptools,
}:
buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "4.1.1";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit version;
    pname = "sqlite_utils";
    hash = "sha256-z5fmILOUDNVByukRfMJK+WGm2kJhif22YvIPGVC6H0k=";
  };

  dependencies = [
    click
    click-default-group
    pip
    pluggy
    python-dateutil
    sqlite-fts4
    tabulate
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "sqlite_utils" ];

  passthru.tests.version = testers.testVersion { package = sqlite-utils; };

  meta = {
    description = "Python CLI utility and library for manipulating SQLite databases";
    mainProgram = "sqlite-utils";
    homepage = "https://github.com/simonw/sqlite-utils";
    changelog = "https://github.com/simonw/sqlite-utils/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      meatcar
      techknowlogick
    ];
  };
}
