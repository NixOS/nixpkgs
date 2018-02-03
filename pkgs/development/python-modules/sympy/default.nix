{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bpzjwr9hrr7w88v4vgnj9lr6vxcldc94si13n8xpr1rv08d5b1y";
  };

  checkInputs = [ glibcLocales ];

  propagatedBuildInputs = [ mpmath ];

  # Bunch of failures including transients.
  doCheck = false;

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  meta = {
    description = "A Python library for symbolic mathematics";
    homepage    = http://www.sympy.org/;
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovek323 ];
  };
}