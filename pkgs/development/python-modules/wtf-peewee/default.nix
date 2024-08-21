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
  version = "3.0.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LQbOWg65rPTSLRVK5vvqmdsRsXaDgcYZ54oqxgpWGRU=";
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
