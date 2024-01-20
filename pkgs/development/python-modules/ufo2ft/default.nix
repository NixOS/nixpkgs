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
, setuptools-scm
, skia-pathops
, ufolib2
}:

buildPythonPackage rec {
  pname = "ufo2ft";
  version = "2.33.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e6p/H1Vub0Ln0VhQvwsVLuD/p8uNG5oCPhfQPCTl1nY=";
  };

  nativeBuildInputs = [
    setuptools-scm
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
