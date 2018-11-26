{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  version = "2.1.1";
  pname = "simpleparse";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n8msk71lpl3kv086xr2sv68ppgz6228575xfnbszc6p1mwr64rg";
  };

  doCheck = false;  # weird error

  meta = with stdenv.lib; {
    description = "A Parser Generator for Python";
    homepage = https://pypi.python.org/pypi/SimpleParse;
    license = licenses.bsd0;
  };

}
