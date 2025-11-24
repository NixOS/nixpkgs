{
  lib,
  booleanoperations,
  buildPythonPackage,
  cffsubr,
  compreffor,
  cu2qu,
  defcon,
  fetchFromGitHub,
  fontmath,
  fonttools,
  pytestCheckHook,
  setuptools-scm,
  skia-pathops,
  syrupy,
  ufolib2,
}:

buildPythonPackage rec {
  pname = "ufo2ft";
  version = "3.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "ufo2ft";
    tag = "v${version}";
    hash = "sha256-TIeq4As5nThYck5jQLTdZySfOg51DtkiiYiiWEVSzxo=";
  };

  build-system = [
    setuptools-scm
  ];

  pythonRelaxDeps = [ "cffsubr" ];

  dependencies = [
    cu2qu
    fontmath
    fonttools
    defcon
    compreffor
    booleanoperations
    cffsubr
    ufolib2
    skia-pathops
  ]
  ++ fonttools.optional-dependencies.lxml
  ++ fonttools.optional-dependencies.ufo;

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # Do not depend on skia.
    "test_removeOverlaps_CFF_pathops"
    "test_removeOverlaps_pathops"
    "test_custom_filters_as_argument"
    "test_custom_filters_as_argument"
    # Some integration tests fail
    "test_compileVariableCFF2"
    "test_compileVariableTTF"
    "test_drop_glyph_names_variable"
    "test_drop_glyph_names_variable"
  ];

  pythonImportsCheck = [ "ufo2ft" ];

  meta = {
    description = "Bridge from UFOs to FontTools objects";
    homepage = "https://github.com/googlefonts/ufo2ft";
    changelog = "https://github.com/googlefonts/ufo2ft/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
