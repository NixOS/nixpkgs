{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f045e8e9ee1293e2d0ab4396950deed71f095a7762f063f3e5f54a839b8d5b4";
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
