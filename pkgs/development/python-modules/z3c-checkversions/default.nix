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
  version = "2.1";
  format = "setuptools";

  # distutils usage
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit version;
    pname = "z3c.checkversions";
    hash = "sha256-j5So40SyJf7XfCz3P9YFR/6z94up3LY2/dfEmmIbxAk=";
  };

  propagatedBuildInputs = [ zc-buildout ];

  nativeCheckInputs = [ zope-testrunner ];

  checkPhase = ''
    ${python.interpreter} -m zope.testrunner --test-path=src []
  '';

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/z3c.checkversions";
    changelog = "https://github.com/zopefoundation/z3c.checkversions/blob/${version}/CHANGES.rst";
    description = "Find newer package versions on PyPI";
    mainProgram = "checkversions";
    license = licenses.zpl21;
  };
}
