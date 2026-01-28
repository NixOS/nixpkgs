{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  peewee,
  wtforms,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "wtf-peewee";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "wtf-peewee";
    tag = finalAttrs.version;
    hash = "sha256-9gVvcPFVA3051Y0sn0mLq1ejKqcGlKZVbIaQ/uH5f4Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
})
