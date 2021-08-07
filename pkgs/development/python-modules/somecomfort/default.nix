{ lib
, buildPythonPackage
, fetchPypi
, prettytable
, requests
}:

buildPythonPackage rec {
  pname = "somecomfort";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "681f44449e8c0a923305aa05aa5262f4d2304a6ecea496caa8d5a51b724a0fef";
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
