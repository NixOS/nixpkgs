{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "1.0.3";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "0avr63rka9lrqngjfmny7hdds4klmg1nriwc7n3kgyrp44z2lk7c";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = https://pypi.python.org/pypi/zodbpickle;
  };
}
