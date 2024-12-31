{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  peewee,
  wtforms,
  python,
}:

buildPythonPackage rec {
  pname = "wtf-peewee";
  version = "3.0.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gZZEam46tk8SJ/ulqKsxvoF3X3PYGfdfyv7P1cDAC5I=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    peewee
    wtforms
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "WTForms integration for peewee models";
    homepage = "https://github.com/coleifer/wtf-peewee/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
