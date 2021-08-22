{ lib
, buildPythonPackage
, fetchPypi
, six
, typing-extensions
, requests
, yarl
}:

buildPythonPackage rec {
  pname = "transmission-rpc";
  version = "3.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36c022fddb45084c0d9f63db34abf79b66a0f2bab6484f4ac32eb2744a06fa15";
  };

  propagatedBuildInputs = [
    six
    typing-extensions
    requests
    yarl
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "transmission_rpc" ];

  meta = with lib; {
    description = "Python module that implements the Transmission bittorent client RPC protocol";
    homepage = "https://pypi.python.org/project/transmission-rpc/";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
