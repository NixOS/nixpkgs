{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "2.3";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5MtccZcF6Lseju5Kok4gcaMJTs8ng9h0B6uCLxZto6I=";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = "https://pypi.python.org/pypi/zodbpickle";
  };
}
