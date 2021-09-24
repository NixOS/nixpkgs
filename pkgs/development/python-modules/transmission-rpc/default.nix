{ lib
, buildPythonPackage
, fetchPypi
, six
, typing-extensions
, requests
, yarl
, pythonOlder
}:

buildPythonPackage rec {
  pname = "transmission-rpc";
  version = "3.2.8";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "821eda19809dca7ad50eaf42ed8debb72ec0e3b1f04f63b8b2414a05075c132e";
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
    homepage = "https://github.com/Trim21/transmission-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
