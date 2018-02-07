{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "0.7.0";
  name = "${pname}-${version}";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "95a247fb17bce980af8d548af70ac5bd1bad22773f242eb8efa24428efa909a8";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = https://pypi.python.org/pypi/zodbpickle;
  };
}
