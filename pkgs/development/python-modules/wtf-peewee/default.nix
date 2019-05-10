{ stdenv
, buildPythonPackage
, python
, fetchPypi
, flask
, peewee
, wtforms
}:

buildPythonPackage rec {
  pname = "wtf-peewee";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10qjhyhcfvvfwhsx4ldc58gyrp2zm1pigygw4wrxm5c5dh9mvl5c";
  };

  buildInputs = [ peewee wtforms ];

  propagatedBuildInputs = [
    peewee
    wtforms
  ];

  meta = with stdenv.lib; {
    description = "WTForms integration for peewee";
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/coleifer/wtf-peewee;
  };
}
