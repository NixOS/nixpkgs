{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "3.2.0";
  disabled = isPyPy || (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "abb1996ba1c1d2faf5b1e38efa97da7f64e5373a31f705b96fe0587f5f778db4";
  };

  nativeBuildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/ujson";
    description = "Ultra fast JSON encoder and decoder for Python";
    license = licenses.bsd3;
  };

}
