{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.1.8";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f8f88fc7fe0ba81a7558902f87df31c052e27404caa26a160174747afcaebe49";
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
