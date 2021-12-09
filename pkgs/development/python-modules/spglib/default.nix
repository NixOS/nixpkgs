{ lib, buildPythonPackage, fetchPypi, numpy, nose, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.16.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff1420967d64c2d4f0d747886116a6836d9b473454cdd73d560dbfe973a8a038";
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

