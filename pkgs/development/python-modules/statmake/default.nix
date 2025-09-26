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
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "statmake";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "daltonmaag";
    repo = "statmake";
    tag = "v${version}";
    hash = "sha256-UqL3l27Icu5DoVvFYctbOF7gvKvVV6hK1R5A1y9SYkU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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
    changelog = "https://github.com/daltonmaag/statmake/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
