{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "transmissionrpc";
  version = "0.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7EO0YPn94vrtv6bWY+9JWz/WnfhVoTXuvo+KdBwN3mA=";
  };

  propagatedBuildInputs = [ six ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "transmissionrpc" ];

  meta = with lib; {
    description = "Python implementation of the Transmission bittorent client RPC protocol";
    homepage = "https://pypi.python.org/pypi/transmissionrpc/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
