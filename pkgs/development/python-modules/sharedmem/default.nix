{ buildPythonPackage, fetchPypi, lib, numpy }:

buildPythonPackage rec {

  pname = "sharedmem";
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "483e414b8c5d03093a02baf548449f1d8426a88855556fa42102bba82b86b2a8";
  };

  propagatedBuildInputs = [ numpy ];

  meta = {
    homepage = "http://rainwoodman.github.io/sharedmem/";
    description = "Easier parallel programming on shared memory computers";
    maintainers = with lib.maintainers; [ edwtjo ];
    license = lib.licenses.gpl3;
  };
}
