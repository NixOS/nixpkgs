{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # build-system
  hatchling,

  # dependencies
  more-itertools,
  trame-common,
  wslink,
}:
buildPythonPackage (finalAttrs: {
  pname = "trame-server";
  version = "3.13.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame_server";
    hash = "sha256-ORIK4lGcpgKgmGGGlJ+X7XkjUlzJem7ejlYmOn9IVJ8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    more-itertools
    trame-common
    wslink
  ];

  pythonImportsCheck = [
    "trame_server"
    "trame_server.client"
    "trame_server.controller"
    "trame_server.core"
    "trame_server.http"
    "trame_server.protocol"
    "trame_server.state"
    "trame_server.ui"
    "trame_server.utils"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Internal server side implementation of trame";
    homepage = "https://github.com/Kitware/trame-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
