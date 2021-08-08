{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "4.0.2";
  disabled = isPyPy || (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "c615a9e9e378a7383b756b7e7a73c38b22aeb8967a8bfbffd4741f7ffd043c4d";
  };

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/ujson";
    description = "Ultra fast JSON encoder and decoder for Python";
    license = licenses.bsd3;
  };

}
