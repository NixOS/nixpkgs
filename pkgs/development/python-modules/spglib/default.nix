{ stdenv, buildPythonPackage, fetchPypi, numpy, python }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.10.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a50c48dfea450c431a6d6790aa2ebbb10dc43eef97f2794f5038ed1eeecbd30";
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

