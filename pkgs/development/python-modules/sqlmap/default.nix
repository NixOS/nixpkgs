{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.1.12";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86a1078ceb1e79f891633c7e4c7b07949fd9135a0e4c0738abd5111e2e6b96c0";
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
