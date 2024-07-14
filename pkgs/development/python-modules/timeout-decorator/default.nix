{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "timeout-decorator";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ai8vWNscWySizHneY0V2A3eti9wTgT9SZfbD5j0Ws9c=";
  };

  meta = with lib; {
    description = "Timeout decorator";
    license = licenses.mit;
    homepage = "https://github.com/pnpnpn/timeout-decorator";
  };
}
