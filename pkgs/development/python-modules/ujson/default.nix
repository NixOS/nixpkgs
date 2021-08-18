{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "4.1.0";
  disabled = isPyPy || (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IrY+xECfDS8sTJ1aozGZfgJHC3oVoyM/PMMvL5uS1Yw=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/ujson";
    description = "Ultra fast JSON encoder and decoder for Python";
    license = licenses.bsd3;
  };

}
