{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  wheel,
  trame-common,
}:

buildPythonPackage (finalAttrs: {
  name = "trame-client";
  version = "3.11.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "trame-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lt0NX206kz8uH7N0Nw5BYoKJojEV5VLyqoT/zPpjibQ=";
  };

  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
  propagatedBuildInputs = [
    trame-common
  ];

  pythonImportsCheck = [
    "trame_client.encoders"
    "trame_client.module"
    "trame_client.resources"
    "trame_client.ui"
    "trame_client.utils"
    "trame_client.widgets"
  ];

  meta = {
    description = "Internal client side implementation of trame";
    homepage = "https://github.com/kitware/trame-client";
    maintainers = with lib.maintainers; [ BrockoliniMorgan ];
    license = lib.licenses.mit;
  };
})
