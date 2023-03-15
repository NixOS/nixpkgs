{ buildPythonPackage
# pkgs dependencies
, check
, cppunit
, pkg-config
, subunit
, pythonOlder

# python dependencies
, fixtures
, hypothesis
, pytestCheckHook
, setuptools
, testscenarios
, testtools
}:

buildPythonPackage {
  inherit (subunit) name src meta;
  format = "pyproject";

  disabled = pythonOlder "3.6";

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=VERSION" 'version="${subunit.version}"'
  '';

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];

  buildInputs = [ check cppunit ];
  propagatedBuildInputs = [ testtools ];

  nativeCheckInputs = [
    testscenarios
    hypothesis
    fixtures
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "python/subunit"
  ];

  disabledTestPaths = [
    # these tests require testtools and don't work with pytest
    "python/subunit/tests/test_output_filter.py"
    "python/subunit/tests/test_test_protocol.py"
    "python/subunit/tests/test_test_protocol2.py"
  ];
}
