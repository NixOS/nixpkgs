{ lib
, attrs
, buildPythonPackage
, cattrs
, exceptiongroup
, fetchFromGitHub
, fonttools
, fs
, importlib-metadata
, poetry-core
, pytestCheckHook
, pythonOlder
, ufo2ft
, ufoLib2
}:

buildPythonPackage rec {
  pname = "statmake";
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "daltonmaag";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BpxjAr65ZQEJ0PSUIPtS78UvJbMG91qkV8py2K/+W2E=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
    fonttools
    # required by fonttools[ufo]
    fs
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    ufo2ft
    ufoLib2
  ];

  pythonImportsCheck = [
    "statmake"
  ];

  disabledTests = [
    # Test requires an update as later cattrs is present in Nixpkgs
    # https://github.com/daltonmaag/statmake/issues/42
    "test_load_stylespace_broken_range"
  ];

  meta = with lib; {
    description = "Applies STAT information from a Stylespace to a variable font";
    homepage = "https://github.com/daltonmaag/statmake";
    changelog = "https://github.com/daltonmaag/statmake/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
