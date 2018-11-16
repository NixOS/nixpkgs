{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "1.0.2";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "f26e6eba6550ff1575ef2f2831fc8bc0b465f17f9757d0b6c7db55fab5702061";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = https://pypi.python.org/pypi/zodbpickle;
  };
}
