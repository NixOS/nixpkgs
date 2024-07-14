{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "sdnotify";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    hash = "sha256-c5d/x0azbMQRhN1Dw/6BMj57iwbCuwgmxPWaIMVrufE=";
    inherit pname version;
  };

  meta = with lib; {
    description = "Pure Python implementation of systemd's service notification protocol";
    homepage = "https://github.com/bb4242/sdnotify";
    license = licenses.mit;
    maintainers = with maintainers; [ pmiddend ];
  };
}
