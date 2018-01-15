{ lib
, buildPythonPackage
, fetchPypi
, supervise
, isPy3k
, whichcraft
}:

buildPythonPackage rec {
  pname = "supervise_api";
  version = "0.2.0";

  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6982633a924cb5192d2291d25b366ff311876a31b0f5961471b39d87397ef5b";
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
