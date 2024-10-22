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
  version = "0.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mZEnYVM5r4utiGwM7bp2SwaDjYsH8AR/Qm5UdPNke0w=";
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
