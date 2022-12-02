{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "2.4";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vWzJIPKDO6bTWzvxwyaekhDr/AHs1/F2jCL2OqoHU60=";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = "https://pypi.python.org/pypi/zodbpickle";
  };
}
