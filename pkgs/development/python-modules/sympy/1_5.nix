{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.5.1"; # Upgrades may break sage. Please test or ping @timokau.

  src = fetchPypi {
    inherit pname version;
    sha256 = "d77901d748287d15281f5ffe5b0fef62dd38f357c2b827c44ff07f35695f4e7e";
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
