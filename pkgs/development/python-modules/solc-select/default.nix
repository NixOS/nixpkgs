{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "solc-select";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6VawTcffIgnR+zuC4rti+Ocwu1VMTX+VihT/L7LzchI=";
  };

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
