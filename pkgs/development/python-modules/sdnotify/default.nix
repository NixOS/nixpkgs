{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "sdnotify";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    hash = "sha256-c5d/x0azbMQRhN1Dw/6BMj57iwbCuwgmxPWaIMVrufE=";
    inherit (finalAttrs) pname version;
  };

  meta = {
    description = "Pure Python implementation of systemd's service notification protocol";
    homepage = "https://github.com/bb4242/sdnotify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pmiddend ];
  };
})
