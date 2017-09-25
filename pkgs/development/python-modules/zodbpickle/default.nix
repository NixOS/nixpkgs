{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "0.6.0";
  name = "${pname}-${version}";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea3248be966159e7791e3db0e35ea992b9235d52e7d39835438686741d196665";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = http://pypi.python.org/pypi/zodbpickle;
  };
}
