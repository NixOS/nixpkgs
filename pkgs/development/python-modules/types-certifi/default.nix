{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-certifi";
  version = "2021.10.8.3";
  pyproject = true;

  # Building typeshed subpackages from the GitHub repository requires packaging
  # https://github.com/typeshed-internal/stub_uploader
  # The switch to fetchFromGitHub can be made at once for all applicable types-*
  # packages once stub_uploader is packaged
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-cs93mNFlvAt24cEN0eowl8cGPELCHWZFI7ko6ItVSk8=";
  };

  build-system = [ setuptools ];

  # No tests
  doCheck = false;

  meta = {
    description = "Typing stubs for certifi";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Kharacternyk ];
  };
})
