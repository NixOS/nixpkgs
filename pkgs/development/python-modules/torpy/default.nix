{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "torpy";
  version = "1.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "torpyorg";
    repo = "torpy";
    rev = "v${version}";
    hash = "sha256-Ni7GcpkxzAMtP4wBOFsi4KnxK+nC0XCZR/2Z/eS/C+w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # requires network
    "tests/integration"
  ];

  pythonImportsCheck = [ "cryptography" ];

  meta = {
    description = "Pure python Tor client";
    homepage = "https://github.com/torpyorg/torpy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ larsr ];
  };
}
