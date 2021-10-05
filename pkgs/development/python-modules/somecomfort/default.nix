{ lib
, buildPythonPackage
, fetchPypi
, prettytable
, requests
}:

buildPythonPackage rec {
  pname = "somecomfort";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f201109104a61d05624022d3d0ebf23bf487570408517cac5f3f79dbde4b225d";
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
