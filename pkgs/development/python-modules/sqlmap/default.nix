{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s6lgp66bn0l4a5mwxiv9h04sa7braqvjskns315lb93lyb4y092";
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
