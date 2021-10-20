{ lib
, buildPythonPackage
, fetchPypi
, prettytable
, requests
}:

buildPythonPackage rec {
  pname = "somecomfort";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56e60e4e9f76c12c0c9dd1016e9f1334be6800409e0762f5f143f9069d7292d3";
  };

  propagatedBuildInputs = [
    requests
    prettytable
  ];

  # tests require network access
  doCheck = false;

  pythonImportsCheck = [ "somecomfort" ];

  meta = with lib; {
    description = "Client for Honeywell's US-based cloud devices";
    homepage = "https://github.com/kk7ds/somecomfort";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
