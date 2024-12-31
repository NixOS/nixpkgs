{
  lib,
  booleanoperations,
  buildPythonPackage,
  cffsubr,
  compreffor,
  cu2qu,
  defcon,
  fetchPypi,
  fetchpatch2,
  fontmath,
  fonttools,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  skia-pathops,
  syrupy,
  ufolib2,
}:

buildPythonPackage rec {
  pname = "ufo2ft";
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lw5mLcVw1NFT1c/AOcMyo2a8aGOyxFG+ZAU6Ggnssko=";
  };

  patches = [
    (fetchpatch2 {
      # update syrupy snapshots
      url = "https://github.com/googlefonts/ufo2ft/commit/7a3edb2e4202cf388e3ffe31b5b3783dbb392db2.patch";
      hash = "sha256-YEgUgrtgH3PBZlt+xoJme+oPRuDMwq7M/4cJ3JbeuyU=";
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
