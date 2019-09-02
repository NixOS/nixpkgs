{ stdenv, buildPythonPackage, fetchPypi, numpy, nose, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.12.2.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15b02b74c0f06179bc3650c43a710a5200abbba387c6eda3105bfd9236041443";
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

