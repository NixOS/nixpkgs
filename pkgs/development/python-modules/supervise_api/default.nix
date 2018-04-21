{ lib
, buildPythonPackage
, fetchPypi
, supervise
, isPy3k
, whichcraft
}:

buildPythonPackage rec {
  pname = "supervise_api";
  version = "0.4.0";

  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "029h1mlfhkm9lw043rawh24ld8md620y94k6c1l9hs5vvyq4fs84";
  };

  propagatedBuildInputs = [
    supervise
  ] ++ lib.optionals ( !isPy3k ) [
    whichcraft
  ];

  # no tests
  doCheck = false;

  meta = {
    description = "An API for running processes safely and securely";
    homepage = https://github.com/catern/supervise;
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ catern ];
  };
}
