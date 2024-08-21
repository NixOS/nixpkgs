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
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.36";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3MMROU/obcFvZQN7AHXiOO/P0uEuZdU+0ZaVRQKZbzw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "click-default-group-wheel" "click-default-group"
  '';

  propagatedBuildInputs = [
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
