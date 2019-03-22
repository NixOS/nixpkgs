{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1010623c4c31413fdfdd8b3fe194ab95dfabde1081f3c707d1b2eb56b044a7da";
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
