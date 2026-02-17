{
  lib,
  attrs,
  buildPythonPackage,
  cattrs,
  fetchFromGitHub,
  fonttools,
  fs,
  poetry-core,
  pytestCheckHook,
  ufo2ft,
  ufolib2,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "statmake";
  version = "1.1.0";
  pyproject = true;

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
  ];

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
