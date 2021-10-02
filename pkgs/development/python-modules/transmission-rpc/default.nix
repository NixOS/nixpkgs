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
  version = "3.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef3a931fc1f1db74edf8660e475b9295e0904ee922030ef0e45b0c73f4be65ae";
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
