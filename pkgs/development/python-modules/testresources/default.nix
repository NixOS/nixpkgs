{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pbr,
  fixtures,
  testtools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "testresources";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7p0ZghVKHiEtTkusa2EIAL+1WOT7hTVyqCe8FKluRBc=";
  };

  postPatch = ''
    substituteInPlace testresources/tests/test_resourced_test_case.py \
      --replace "failIf" "assertFalse"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pbr ];

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
