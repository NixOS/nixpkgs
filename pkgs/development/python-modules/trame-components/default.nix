{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # build-system
  setuptools,

  # dependencies
  trame-client,
}:
buildPythonPackage (finalAttrs: {
  pname = "trame-components";
  version = "2.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame-components";
    hash = "sha256-33odOHuYxd1xaZc3gE9SiJV8o3DrGmC75A6Jofn2KxI=";
  };

  build-system = [ setuptools ];

  dependencies = [ trame-client ];

  postPatch = ''
    find trame -type f -name '__init__.py' -delete
  '';

  pythonImportsCheck = [
    "trame_components.module"
    "trame_components.widgets"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Core widgets for trame";
    homepage = "https://github.com/kitware/trame-components";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
