{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pbr
, fixtures
, testtools
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "testresources";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee9d1982154a1e212d4e4bac6b610800bfb558e4fb853572a827bc14a96e4417";
  };

  postPatch = ''
    substituteInPlace testresources/tests/test_resourced_test_case.py \
      --replace "failIf" "assertFalse"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pbr
  ];

  nativeCheckInputs = [
    fixtures
    testtools
    unittestCheckHook
  ];

  meta = with lib; {
    description = "Pyunit extension for managing expensive test resources";
    homepage = "https://launchpad.net/testresources";
    license = licenses.bsd2;
  };
}
