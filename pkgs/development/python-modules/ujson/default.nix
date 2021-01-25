{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "4.0.1";
  disabled = isPyPy || (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "26cf6241b36ff5ce4539ae687b6b02673109c5e3efc96148806a7873eaa229d3";
  };

  nativeBuildInputs = [ setuptools_scm ];

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/ujson";
    description = "Ultra fast JSON encoder and decoder for Python";
    license = licenses.bsd3;
  };

}
