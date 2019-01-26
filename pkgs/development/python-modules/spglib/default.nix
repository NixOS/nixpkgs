{ stdenv, buildPythonPackage, fetchPypi, numpy, python }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.10.4.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13b0a227d2dc4079fe36d5bcce4e672400c7c5dfc5d3cd25ccb9521ef592d93e";
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

