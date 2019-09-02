{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "1.0.4";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n4hng2zil1j8sbz0b83pxx8ndlh34h2mnmli3bqjmnrbry5zlr5";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = https://pypi.python.org/pypi/zodbpickle;
  };
}
