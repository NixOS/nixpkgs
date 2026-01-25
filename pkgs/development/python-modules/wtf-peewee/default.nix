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
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y2eVVl0Tg5K1Iw3lE6icxq0AJKdqfIBt20wQdSO19Bo=";
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

  meta = {
    description = "WTForms integration for peewee models";
    homepage = "https://github.com/coleifer/wtf-peewee/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
