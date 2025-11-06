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
  version = "0.0.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "unicrypto";
    tag = version;
    hash = "sha256-quMh4yQSqbwZwWTJYxW/4F0k2c2nh82FEiNCSeQzhvo=";
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
