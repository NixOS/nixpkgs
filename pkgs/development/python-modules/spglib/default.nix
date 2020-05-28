{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, numpy, nose, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c1nbpd5wy361xga8lw36xwc9yyz7rylsjr0z7aw7bn3s35bnkbx";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ nose pyyaml ];

  meta = with stdenv.lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = "https://atztogo.github.io/spglib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}

