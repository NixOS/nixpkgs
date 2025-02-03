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
    sha256 = "ec43b460f9fde2faedbfa6d663ef495b3fd69df855a135eebe8f8a741c0dde60";
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
