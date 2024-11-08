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
  version = "1.13.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sn/SxlMOCrOeJ1/JtoOJU2flHV2pG6qNPWTbJWX+xNk=";
  };

  nativeCheckInputs = [ glibcLocales ];

  propagatedBuildInputs = [ mpmath ];

  # tests take ~1h
  doCheck = false;
  pythonImportsCheck = [ "sympy" ];

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "Python library for symbolic mathematics";
    mainProgram = "isympy";
    homepage = "https://www.sympy.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ] ++ teams.sage.members;
  };
}
