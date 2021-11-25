{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "0.10.0";
  pname = "websockify";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c4cc1bc132abb4a99834bcb1b4bd72f51d35a08d08093a817646ecc226ac44e";
  };

  propagatedBuildInputs = [ numpy ];

  # Ran 0 tests in 0.000s
  doCheck = false;

  pythonImportsCheck = [ "websockify" ];

  meta = with lib; {
    description = "WebSockets support for any application/server";
    homepage = "https://github.com/kanaka/websockify";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
