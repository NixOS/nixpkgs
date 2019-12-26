{ lib
, buildPythonPackage
, fetchPypi
, peewee
, wtforms
, python
}:

buildPythonPackage rec {
  pname = "wtf-peewee";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acd05d136c8595da3327fcf9176fa85fdcec1f2aac51d235e46e6fc7a0871283";
  };

  propagatedBuildInputs = [
    peewee
    wtforms
  ];

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  meta = with lib; {
    description = "WTForms integration for peewee models";
    homepage = https://github.com/coleifer/wtf-peewee/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
