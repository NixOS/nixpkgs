{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pycryptodome
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

  meta = with lib; {
    description = "Manage and switch between Solidity compiler versions";
    homepage = "https://github.com/crytic/solc-select";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ arturcygan ];
  };
}
