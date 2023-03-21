{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xrskWqhox914w7Fr1ISEzTZhJ9YeTvoVZ26sI6zYK3Y=";
  };

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for colorama";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
