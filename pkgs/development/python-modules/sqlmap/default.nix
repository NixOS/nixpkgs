{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18ac6392a710f0cc106c28c4e27e43e8f1b25cb46fb8b6714836212607c07b10";
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
