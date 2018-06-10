{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac5b57691bc43919dcc21167660a57cc51797c28a4301a6144eff07b751216a4";
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