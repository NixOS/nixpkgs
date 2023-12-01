{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, peewee
, wtforms
, python
}:

buildPythonPackage rec {
  pname = "wtf-peewee";
  version = "3.0.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cTbYRdvAUTY86MPR33BH+nA6H/epR8sgHDgOBQ/TUkQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
