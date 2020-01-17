{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, numpy, nose, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.14.1.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kmllcch5p20ylxirqiqzls567jr2808rbld9i8f1kf0205al8qq";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ nose pyyaml ];

  meta = with stdenv.lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = https://atztogo.github.io/spglib;
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}

