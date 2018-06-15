{ stdenv, buildPythonPackage, fetchPypi, numpy, python }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.10.3.65";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55b49227835396b2bcd6afe724e9f37202ad0f61e273bedebd5bf740bad2e8e3";
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

