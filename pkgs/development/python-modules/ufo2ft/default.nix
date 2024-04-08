{ lib
, booleanoperations
, buildPythonPackage
, cffsubr
, compreffor
, cu2qu
, defcon
, fetchPypi
, fonttools
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools-scm
, skia-pathops
, ufolib2
}:

buildPythonPackage rec {
  pname = "ufo2ft";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5EUrML1Yd88tVEP+Kd9TmXm+5Ejk/XIH/USYBakK/wQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "cffsubr"
  ];

  propagatedBuildInputs = [
    cu2qu
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

  pythonImportsCheck = [
    "ufo2ft"
  ];

  meta = with lib; {
    description = "Bridge from UFOs to FontTools objects";
    homepage = "https://github.com/googlefonts/ufo2ft";
    changelog = "https://github.com/googlefonts/ufo2ft/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
