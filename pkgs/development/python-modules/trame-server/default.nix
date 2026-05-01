{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # build-system
  setuptools,

  # dependencies
  more-itertools,
  wslink,
}:
buildPythonPackage (finalAttrs: {
  pname = "trame-server";
  version = "3.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame_server";
    hash = "sha256-DDQd6Xb3WP+OYHaZHn8wvhgDhNTzhs8prvo5FbgB0Rg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    more-itertools
    wslink
  ];

  pythonImportsCheck = [ "trame_server" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Internal server side implementation of trame";
    homepage = "https://github.com/Kitware/trame-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
