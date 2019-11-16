{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, numpy, nose, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.12.2.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15b02b74c0f06179bc3650c43a710a5200abbba387c6eda3105bfd9236041443";
  };

  patches = [
    (fetchpatch {
      name = "fix-assertions.patch";
      url = https://github.com/atztogo/spglib/commit/d57070831585a6f02dec0a31d25b375ba347798c.patch;
      stripLen = 1;
      sha256 = "0crmkc498rbrawiy9zbl39qis2nmsbfr4s6kk6k3zhdy8z2ppxw7";
    })
  ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ nose pyyaml ];

  meta = with stdenv.lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = https://atztogo.github.io/spglib;
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}

