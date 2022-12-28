{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, peewee
, wtforms
, python
}:

buildPythonPackage rec {
  pname = "wtf-peewee";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "faa953fe3f705d4f2b48f3c1a81c5c5a6a38f9ed1378c9a830e6efc1b0fccb15";
  };

  patches = [
    (fetchpatch {
      name = "fix-wtforms3.patch";
      url = "https://github.com/coleifer/wtf-peewee/commit/b1764f4474c73a9a2b34ae6b7db61274f5252a7f.patch";
      sha256 = "0maz3fm9bi8p80nk9sdb34xq55xq8ihm51y7k0m8ck9aaypvwbig";
    })
  ];

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
