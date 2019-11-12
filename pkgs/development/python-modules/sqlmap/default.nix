{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27ef900b1116776128d0d09bff21f8d2f6bb2ea887cd59fe1a32aec5563aacb0";
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
