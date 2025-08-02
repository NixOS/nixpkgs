{
  lib,
  buildPythonPackage,
  fetchPypi,
  packaging,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "solc-select";
  version = "1.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-23ud4AmvbeOlQWuAu+W21ja/MUcDwBYxm4wSMeJIpsc=";
  };

  propagatedBuildInputs = [
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
