{ lib
, buildPythonPackage
, fetchPypi
, prettytable
, requests
}:

buildPythonPackage rec {
  pname = "somecomfort";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CbV8NOpCXzVz0dBKhUclUCPrD4530zv5HIYxsbNO+OA=";
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
