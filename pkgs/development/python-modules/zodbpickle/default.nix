{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "2.1.0";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca6a89b55fd1298bf4a9bc9b5640805792e4c27ebf0153a194ec63b8ec1df2a8";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = "https://pypi.python.org/pypi/zodbpickle";
  };
}
