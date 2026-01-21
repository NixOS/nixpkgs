{
  lib,
  attrs,
  buildPythonPackage,
  cattrs,
  exceptiongroup,
  fetchFromGitHub,
  fonttools,
  fs,
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
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daltonmaag";
    repo = "statmake";
    tag = "v${version}";
    hash = "sha256-PlMbJuJUkUjKXhkcCfLO5G3R1z9Zwf9qKYj9olOANno=";
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
  ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ];

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

  meta = {
    description = "Applies STAT information from a Stylespace to a variable font";
    mainProgram = "statmake";
    homepage = "https://github.com/daltonmaag/statmake";
    changelog = "https://github.com/daltonmaag/statmake/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
