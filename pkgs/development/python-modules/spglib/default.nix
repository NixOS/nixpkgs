{ stdenv, buildPythonPackage, fetchPypi, numpy, python }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.10.3.75";

  src = fetchPypi {
    inherit pname version;
    sha256 = "347fea7c87f7d2162fabb780560665d21a43cbd7a0af08328130ba26e6422143";
  };

  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    cd test
    ${python.interpreter} -m unittest discover -bv
  '';

  meta = with stdenv.lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = https://atztogo.github.io/spglib;
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };

}

