{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.2.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8715529e823c6f4ed701d71f1daf8525583ed04b44e8c89d6781475c856eb2ba";
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
