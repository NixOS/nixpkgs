{
  buildPythonPackage,
  # pkgs dependencies
  check,
  cppunit,
  pkg-config,
  subunit,

  # python dependencies
  fixtures,
  hypothesis,
  iso8601,
  pytestCheckHook,
  setuptools,
  testscenarios,
  testtools,
}:

buildPythonPackage {
  inherit (subunit)
    pname
    version
    src
    meta
    ;
  pyproject = true;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=VERSION" 'version="${subunit.version}"'
  '';

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];

  buildInputs = [
    check
    cppunit
  ];

  propagatedBuildInputs = [
    iso8601
    testtools
  ];

  nativeCheckInputs = [
    testscenarios
    hypothesis
    fixtures
    pytestCheckHook
  ];

  enabledTestPaths = [ "python/subunit" ];

  disabledTestPaths = [
    # these tests require testtools and don't work with pytest
    "python/subunit/tests/test_output_filter.py"
    "python/subunit/tests/test_test_protocol.py"
    "python/subunit/tests/test_test_protocol2.py"
  ];
}
