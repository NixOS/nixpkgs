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
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LL89fgCrLp/iS3VKECZE9vM0JEmARkw4IzsYEn8d6uw=";
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
