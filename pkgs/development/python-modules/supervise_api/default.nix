{ lib
, buildPythonPackage
, fetchPypi
, supervise
, isPy3k
, whichcraft
, utillinux
}:

buildPythonPackage rec {
  pname = "supervise_api";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dakc1h2ih1bw67y137wp0vph8d3y2lx5d70b8dgggy1zbpqxl1m";
  };

  propagatedBuildInputs = [
    supervise
  ] ++ lib.optionals ( !isPy3k ) [
    whichcraft
  ];
  checkInputs = [ utillinux ];

  meta = {
    description = "An API for running processes safely and securely";
    homepage = https://github.com/catern/supervise;
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ catern ];
  };
}
