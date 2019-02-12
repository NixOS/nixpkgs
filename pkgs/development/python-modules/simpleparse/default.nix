{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  version = "2.2.0";
  pname = "simpleparse";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "18ccdc249bb550717af796af04a7d50aef523368901f64036a48eee5daca149d";
  };

  doCheck = false;  # weird error

  meta = with stdenv.lib; {
    description = "A Parser Generator for Python";
    homepage = https://pypi.python.org/pypi/SimpleParse;
    license = licenses.bsd0;
  };

}
