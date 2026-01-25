{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # build-system
  setuptools,
  wheel,

  # dependencies
  trame-common,
}:
buildPythonPackage (finalAttrs: {
  pname = "trame-client";
  version = "3.13.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame_client";
    hash = "sha256-9ICQOOeD9uLe3rt3IVn2/MUB6FQGiIVNYmJlfbh/mgI=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ trame-common ];

  postPatch = ''
    find trame -type f -name '__init__.py' -delete
  '';

  pythonImportsCheck = [
    "trame_client"
    "trame_client.encoders"
    "trame_client.module"
    "trame_client.resources"
    "trame_client.ui"
    "trame_client.utils"
    "trame_client.widgets"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Internal client of trame";
    homepage = "https://github.com/Kitware/trame-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
