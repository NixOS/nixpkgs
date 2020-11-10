{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  version = "2.2.2";
  pname = "simpleparse";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    pname = "SimpleParse";
    inherit version;
    sha256 = "010szm4mbqgfdksa2n4l9avj617rb0gkwrryc70mfjmyww0bd1m6";
  };

  doCheck = false;  # weird error

  meta = with stdenv.lib; {
    description = "A Parser Generator for Python";
    homepage = "https://pypi.python.org/pypi/SimpleParse";
    license = licenses.bsd0;
  };

}
