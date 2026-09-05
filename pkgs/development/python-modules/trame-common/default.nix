{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # build
  hatchling,
}:
buildPythonPackage (finalAttrs: {
  pname = "trame-common";
  version = "1.2.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame_common";
    hash = "sha256-d9BTogFD4oEp6x/L1EgAEjU4AOvy8JxnzXtQRCEIEbE=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "trame_common" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dependency less classes and functions for trame";
    homepage = "https://github.com/Kitware/trame-common";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
