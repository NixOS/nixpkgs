{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.6.1"; # Upgrades may break sage. Please test or ping @timokau.

  src = fetchPypi {
    inherit pname version;
    sha256 = "7386dba4f7e162e90766b5ea7cab5938c2fe3c620b310518c8ff504b283cb15b";
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
    maintainers = with maintainers; [ lovek323 timokau ];
  };
}
