{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "3.0.0";
  disabled = isPyPy || (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "e0199849d61cc6418f94d52a314c6a27524d65e82174d2a043fb718f73d1520d";
  };

  nativeBuildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/ujson";
    description = "Ultra fast JSON encoder and decoder for Python";
    license = licenses.bsd3;
  };

}
