{
  lib,
  booleanoperations,
  buildPythonPackage,
  cffsubr,
  compreffor,
  cu2qu,
  defcon,
  fetchPypi,
  fontmath,
  fonttools,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  skia-pathops,
  syrupy,
  ufolib2,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "ufo2ft";
  version = "3.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FUITbL+FnscmZjZMlgh/dX4+tJR6MD0LoH5jDNisQkI=";
  };

  patches = [
    # Unreleased patch for fonttools >= 4.58.5
    # https://github.com/googlefonts/ufo2ft/issues/920
    (fetchpatch {
      name = "ufo2ft-fonttools-4.58.5.patch";
      url = "https://github.com/googlefonts/ufo2ft/commit/5ca4800ef39167c377fc669b41e146520cfa641b.patch";
      hash = "sha256-7hEO6D7LK+LxTK1jcaC8kLw/9ZOOpr41qFysLrZBZ4M=";
    })
  ];

  build-system = [
    setuptools-scm
  ];

  pythonRelaxDeps = [ "cffsubr" ];

  dependencies =
    [
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

  meta = with lib; {
    description = "Bridge from UFOs to FontTools objects";
    homepage = "https://github.com/googlefonts/ufo2ft";
    changelog = "https://github.com/googlefonts/ufo2ft/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
