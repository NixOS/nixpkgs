{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage (finalAttrs: {
  pname = "timeout-decorator";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ai8vWNscWySizHneY0V2A3eti9wTgT9SZfbD5j0Ws9c=";
  };

  meta = {
    description = "Timeout decorator";
    license = lib.licenses.mit;
    homepage = "https://github.com/pnpnpn/timeout-decorator";
  };
})
