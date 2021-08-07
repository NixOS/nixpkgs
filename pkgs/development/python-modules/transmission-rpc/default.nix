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
  version = "3.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59598c9aa338703951686420fea292d9ba2d83d2a81361f16b64c2603c4ebb45";
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
