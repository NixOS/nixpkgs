{ lib
, buildPythonPackage
, construct
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "snapcast";
  version = "2.1.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ILBleqxEO7wTxAw/fvDW+4O4H4XWV5m5WWtaNeRBr4g=";
  };

  propagatedBuildInputs = [ construct ];

  # no checks from Pypi - https://github.com/happyleavesaoc/python-snapcast/issues/23
  doCheck = false;
  pythonImportsCheck = [ "snapcast" ];

  meta = with lib; {
    description = "Control Snapcast, a multi-room synchronous audio solution";
    homepage = "https://github.com/happyleavesaoc/python-snapcast/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
