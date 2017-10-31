{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.1.10";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90db96664955c6a576b495c973bd3976b9d4eaffaea205c0343ac7e8f8147cbe";
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
