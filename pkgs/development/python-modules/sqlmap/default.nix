{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3bad3275e2f29ffa54d4013a2ac2c77e87d01a1d745065d54ed5e60bc68dfbf0";
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
