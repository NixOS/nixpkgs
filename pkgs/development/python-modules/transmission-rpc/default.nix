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
  version = "3.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k4yyrbdqxp43zsmcg37a99x4s2kwsm7yyajf810y2wx61nq49d1";
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
