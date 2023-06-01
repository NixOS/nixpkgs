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
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.32.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bCj+Mvzr1lihaR3t+k0RFJmtMCzAE5xaWJOlkNRhhIo=";
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [
    "sqlite_utils"
  ];

  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    homepage = "https://github.com/simonw/sqlite-utils";
    changelog = "https://github.com/simonw/sqlite-utils/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ meatcar techknowlogick ];
  };
}
