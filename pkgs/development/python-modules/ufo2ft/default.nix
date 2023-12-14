{ lib
, buildPythonPackage
, fetchPypi

# build
, setuptools-scm

# runtime
, booleanoperations
, cffsubr
, compreffor
, cu2qu
, defcon
, fonttools
, skia-pathops
, ufoLib2

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ufo2ft";
  version = "2.33.4";
  format = "setuptools";

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
    ufoLib2
    skia-pathops
  ]
  ++ fonttools.optional-dependencies.lxml
  ++ fonttools.optional-dependencies.ufo;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # Do not depend on skia.
    "--deselect=tests/integration_test.py::IntegrationTest::test_removeOverlaps_CFF_pathops"
    "--deselect=tests/integration_test.py::IntegrationTest::test_removeOverlaps_pathops"
    "--deselect=tests/preProcessor_test.py::TTFPreProcessorTest::test_custom_filters_as_argument"
    "--deselect=tests/preProcessor_test.py::TTFInterpolatablePreProcessorTest::test_custom_filters_as_argument"
  ];

  pythonImportsCheck = [ "ufo2ft" ];

  meta = with lib; {
    description = "Bridge from UFOs to FontTools objects";
    homepage = "https://github.com/googlefonts/ufo2ft";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
