{
  lib,
  buildPythonPackage,
  fetchPypi,
  glibcLocales,
  mpmath,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.14.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-09P+jfHloLQvDnvfUFQWl9vn0jdG6JSZDAMOKwXnJRc=";
  };

  nativeCheckInputs = [ glibcLocales ];

  propagatedBuildInputs = [ mpmath ];

  # tests take ~1h
  doCheck = false;
  pythonImportsCheck = [ "sympy" ];

  passthru.tests = {
    inherit sage;
  };

<<<<<<< HEAD
  meta = {
    description = "Python library for symbolic mathematics";
    mainProgram = "isympy";
    homepage = "https://www.sympy.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovek323 ];
    teams = [ lib.teams.sage ];
=======
  meta = with lib; {
    description = "Python library for symbolic mathematics";
    mainProgram = "isympy";
    homepage = "https://www.sympy.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    teams = [ teams.sage ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
