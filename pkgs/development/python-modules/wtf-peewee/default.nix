{ lib
, buildPythonPackage
, fetchPypi
, peewee
, wtforms
, python
}:

buildPythonPackage rec {
  pname = "wtf-peewee";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ac1b457f3255ee2d72915267884a16e5fb502e1e7bb793f2f1301c926e3599a";
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
    homepage = "https://github.com/coleifer/wtf-peewee/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
