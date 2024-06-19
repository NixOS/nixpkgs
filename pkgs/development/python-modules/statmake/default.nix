{
  lib,
  attrs,
  buildPythonPackage,
  cattrs,
  exceptiongroup,
  fetchFromGitHub,
  fonttools,
  fs,
  importlib-metadata,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  ufo2ft,
  ufolib2,
}:

buildPythonPackage rec {
  pname = "statmake";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "daltonmaag";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3BZ71JVvj7GCojM8ycu160viPj8BLJ1SiW86Df2fzsw=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs =
    [
      attrs
      cattrs
      fonttools
      # required by fonttools[ufo]
      fs
    ]
    ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [
    pytestCheckHook
    ufo2ft
    ufolib2
  ];

  pythonImportsCheck = [ "statmake" ];

  disabledTests = [
    # Test requires an update as later cattrs is present in Nixpkgs
    # https://github.com/daltonmaag/statmake/issues/42
    "test_load_stylespace_broken_range"
  ];

  meta = with lib; {
    description = "Applies STAT information from a Stylespace to a variable font";
    mainProgram = "statmake";
    homepage = "https://github.com/daltonmaag/statmake";
    changelog = "https://github.com/daltonmaag/statmake/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
