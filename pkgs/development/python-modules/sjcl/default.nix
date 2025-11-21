{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pycryptodome,
}:

buildPythonPackage {
  pname = "sjcl";
  version = "0.2.1";
  pyproject = true;

  # PyPi release is missing tests
  src = fetchFromGitHub {
    owner = "berlincode";
    repo = "sjcl";
    # commit from: 2018-08-16, because there aren't any tags on git
    rev = "e8bdad312fa99c89c74f8651a1240afba8a9f3bd";
    hash = "sha256-S4GhNdnL+WvYsnyzP0zkBYCqyJBbsW4PZWgjsUthGe0=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycryptodome ];

  pythonImportsCheck = [ "sjcl" ];

  meta = {
    description = "Decrypt and encrypt messages compatible to the \"Stanford Javascript Crypto Library (SJCL)\" message format";
    homepage = "https://github.com/berlincode/sjcl";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ binsky ];
  };
}
