{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4yOA3OY8t8AQjtUlVwCS/UUWi9ri+qF+UoIh73Lohlg=";
  };

  nativeCheckInputs = [ glibcLocales ];

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
