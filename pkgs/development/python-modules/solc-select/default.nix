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
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "solc-select";
    tag = "v${version}";
    hash = "sha256-ZB9WM6YTWEqfs5y1DqxbSADiFw997PHIR9uVSjJg1/E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    packaging
    pycryptodome
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "solc_select" ];

  meta = with lib; {
    description = "Manage and switch between Solidity compiler versions";
    homepage = "https://github.com/crytic/solc-select";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ arturcygan ];
  };
}
