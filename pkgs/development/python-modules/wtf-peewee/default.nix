{ lib
, buildPythonPackage
, fetchPypi
, peewee
, wtforms
, python
}:

buildPythonPackage rec {
  pname = "wtf-peewee";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03qs6np5s9r0nmsryfzll29ajcqk27b18kcbgd9plf80ys3nb6kd";
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
