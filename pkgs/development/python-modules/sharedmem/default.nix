{ buildPythonPackage, fetchPypi, lib, numpy }:

buildPythonPackage rec {

  pname = "sharedmem";
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wr438m1jmcj6ccskzm6pchv6ldx7031h040adadjmkivz5rry41";
  };

  propagatedBuildInputs = [ numpy ];

  meta = {
    homepage = http://rainwoodman.github.io/sharedmem/;
    description = "Easier parallel programming on shared memory computers";
    maintainers = with lib.maintainers; [ edwtjo ];
    license = lib.licenses.gpl3;
  };
}
