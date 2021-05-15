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
  version = "3.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f852d1afd0f0d4f515fe20f0de94d57b6d2e36cbac45e07da43ea0b6518f535c";
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
