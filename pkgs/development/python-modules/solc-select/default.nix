{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pycryptodome
}:

buildPythonPackage rec {
  pname = "solc-select";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-850IA1NVvQ4KiH5KEIjqEKFd1k5ECMx/zXLZE7Rvx5k=";
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
