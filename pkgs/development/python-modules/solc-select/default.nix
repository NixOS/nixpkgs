{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "solc-select";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "solc-select";
    tag = "v.${version}";
    hash = "sha256-pPDiP8GNE/KAFS4Jm6jLpKozktxy70+f00QFUa4wMiQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    packaging
    pycryptodome
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "solc_select" ];

  meta = {
    description = "Manage and switch between Solidity compiler versions";
    homepage = "https://github.com/crytic/solc-select";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ arturcygan ];
  };
}
