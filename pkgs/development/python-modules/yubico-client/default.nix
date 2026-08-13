{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "yubico-client";
  version = "1.13.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-47hs0qEjEF7frK1AVRx7JunBGT2B/+Fo7nBOv9PREWI=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # pypi package missing test_utils and github releases is behind
  doCheck = false;

  pythonImportsCheck = [ "yubico_client" ];

  meta = {
    description = "Verifying Yubico OTPs based on the validation protocol version 2.0";
    homepage = "https://github.com/Kami/python-yubico-client/";
    license = lib.licenses.bsd3;
  };
})
