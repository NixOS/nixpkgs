{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, numpy, nose, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "94d056e48e7e6fe2e6fe4161471e774ac03221a6225fd83d551d3184220c1edf";
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

