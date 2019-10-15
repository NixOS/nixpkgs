{ buildPythonPackage, fetchPypi, lib, numpy }:

buildPythonPackage rec {

  pname = "sharedmem";
  version = "0.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c351ab3f6a4fe9fe0c692ab6a8c88013e625845b31a168ff12d16254ed4154d5";
  };

  propagatedBuildInputs = [ numpy ];

  meta = {
    homepage = http://rainwoodman.github.io/sharedmem/;
    description = "Easier parallel programming on shared memory computers";
    maintainers = with lib.maintainers; [ edwtjo ];
    license = lib.licenses.gpl3;
  };
}
