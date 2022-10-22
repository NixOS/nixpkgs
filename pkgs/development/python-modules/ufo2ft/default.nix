{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, fonttools
, defcon
, compreffor
, booleanoperations
, cffsubr
, ufoLib2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ufo2ft";
  version = "2.28.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pWHvjAvHNWlmJiQ75JRmFyrjYnzbJG7M8/DGoIWpEBk=";
  };

  patches = [
    # Use cu2qu from fonttools.
    # https://github.com/googlefonts/ufo2ft/pull/461
    ./fonttools-cu2qu.patch
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fonttools
    defcon
    compreffor
    booleanoperations
    cffsubr
    ufoLib2
  ];

  checkInputs = [
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
    maintainers = with maintainers; [ jtojnar ];
  };
}
