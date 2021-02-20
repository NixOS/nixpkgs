{ lib, buildPythonPackage, fetchPypi, fetchpatch, numpy, nose, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fd2fefbd83993b135877a69c498d8ddcf20a9980562b65b800cfb4cdadad003";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ nose pyyaml ];

  meta = with lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = "https://atztogo.github.io/spglib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}

