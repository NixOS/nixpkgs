{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pycryptodome
}:

buildPythonPackage rec {
  pname = "solc-select";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zrpWHQdoCVDGaDGDf9fWhnRsTe1GVwqk1qls1PyvlLw=";
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
