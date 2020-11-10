{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "3.1.0";
  disabled = isPyPy || (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "00bda1de275ed6fe81817902189c75dfd156b4fa29b44dc1f4620775d2f50cf7";
  };

  nativeBuildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/ujson";
    description = "Ultra fast JSON encoder and decoder for Python";
    license = licenses.bsd3;
  };

}
