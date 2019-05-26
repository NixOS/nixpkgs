{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "894584fdb8d0e25e9f9ac0da20058e23c27d5ca55904cc0326e1a84101beef32";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "http://sqlmap.org";
    license = licenses.gpl2;
    description = "Automatic SQL injection and database takeover tool";
    maintainers = with maintainers; [ bennofs ];
  };
}
