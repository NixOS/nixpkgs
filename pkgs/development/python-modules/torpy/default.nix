{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cryptography,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "torpy";
  version = "1.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "torpyorg";
    repo = "torpy";
    rev = "v${version}";
    hash = "sha256-Ni7GcpkxzAMtP4wBOFsi4KnxK+nC0XCZR/2Z/eS/C+w=";
  };

  propagatedBuildInputs = [
    cryptography
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # requires network
    "tests/integration"
  ];

  pythonImportsCheck = [ "cryptography" ];

  meta = with lib; {
    description = "Pure python Tor client";
    homepage = "https://github.com/torpyorg/torpy";
    license = licenses.asl20;
    maintainers = with maintainers; [ larsr ];
  };
}
