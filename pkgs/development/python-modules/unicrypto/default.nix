{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  pycryptodomex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "unicrypto";
  version = "0.0.12";
  format = "";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "unicrypto";
    tag = version;
    hash = "sha256-RYwovFMalBNDPDEVjQ/8/N7DkOMiyeEQ5ESdgCK8RW8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodome
    pycryptodomex
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "unicrypto" ];

  meta = with lib; {
    description = "Unified interface for cryptographic libraries";
    homepage = "https://github.com/skelsec/unicrypto";
    changelog = "https://github.com/skelsec/unicrypto/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
