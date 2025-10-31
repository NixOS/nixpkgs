{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  pycryptodomex,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "unicrypto";
  version = "0.0.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "unicrypto";
    tag = version;
    hash = "sha256-RYwovFMalBNDPDEVjQ/8/N7DkOMiyeEQ5ESdgCK8RW8=";
  };

  propagatedBuildInputs = [
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
