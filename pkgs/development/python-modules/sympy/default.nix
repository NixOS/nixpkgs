{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-o96SYel1Nbg7uGB7DaLH0DEmZQ+v6isniWV7Ipwkay4=";
  };

  checkInputs = [ glibcLocales ];

  propagatedBuildInputs = [ mpmath ];

  # tests take ~1h
  doCheck = false;
  pythonImportsCheck = [ "sympy" ];

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  meta = with lib; {
    description = "A Python library for symbolic mathematics";
    homepage    = "https://www.sympy.org/";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ] ++ teams.sage.members;
  };
}
