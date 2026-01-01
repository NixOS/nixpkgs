{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonAtLeast,
  zc-buildout,
  zope-testrunner,
}:

buildPythonPackage rec {
  pname = "z3c-checkversions";
  version = "3.0";
  format = "setuptools";

  # distutils usage
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit version;
    pname = "z3c.checkversions";
    hash = "sha256-VMGSlocgEddBrUT0A4ihtCdhSbirWYe9FmQ0QyOGOEs=";
  };

  propagatedBuildInputs = [ zc-buildout ];

  nativeCheckInputs = [ zope-testrunner ];

  checkPhase = ''
    ${python.interpreter} -m zope.testrunner --test-path=src []
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/zopefoundation/z3c.checkversions";
    changelog = "https://github.com/zopefoundation/z3c.checkversions/blob/${version}/CHANGES.rst";
    description = "Find newer package versions on PyPI";
    mainProgram = "checkversions";
<<<<<<< HEAD
    license = lib.licenses.zpl21;
=======
    license = licenses.zpl21;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
