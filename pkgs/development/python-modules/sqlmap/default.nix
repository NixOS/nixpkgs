{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3649f9b5219b7336b82d3a1bf6e91c8d649171b96747b927a92ac075947d619";
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
