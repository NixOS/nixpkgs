{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "1.0";
  name = "${pname}-${version}";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "3af9169fb1d5901cf6693ab356b0dfda20ad2cacc5673fad59b4449ed50d5399";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = https://pypi.python.org/pypi/zodbpickle;
  };
}
