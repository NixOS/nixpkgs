{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, click
, click-default-group
, python-dateutil
, sqlite-fts4
, tabulate
, pluggy
, pytestCheckHook
, hypothesis
, testers
, sqlite-utils
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.35.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WQsUrSd5FMs/x9XiVHZIR/rNqqI8e6/YXsk4dPb0IUM=";
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

  pythonImportsCheck = [
    "sqlite_utils"
  ];

  passthru.tests.version = testers.testVersion {
    package = sqlite-utils;
  };

  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    homepage = "https://github.com/simonw/sqlite-utils";
    changelog = "https://github.com/simonw/sqlite-utils/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ meatcar techknowlogick ];
  };
}
