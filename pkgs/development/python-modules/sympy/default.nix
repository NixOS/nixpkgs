{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.5"; # Upgrades may break sage. Please test or ping @timokau.

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s4w7q8gndim2ky825a84jmwcf7ryfn10wm8yxz9dw5z2307smii";
  };

  checkInputs = [ glibcLocales ];

  propagatedBuildInputs = [ mpmath ];

  # tests take ~1h
  doCheck = false;

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  meta = {
    description = "A Python library for symbolic mathematics";
    homepage    = https://www.sympy.org/;
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovek323 timokau ];
  };
}
