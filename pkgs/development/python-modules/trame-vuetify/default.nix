{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # build-system
  setuptools,
  wheel,

  # dependencies
  trame-client,
}:
buildPythonPackage (finalAttrs: {
  pname = "trame-vuetify";
  version = "3.2.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame_vuetify";
    hash = "sha256-rsGMWB7vDutBpkvFDlL0hn6kB3fwAsB5oKknpz+Z/E0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ trame-client ];

  postPatch = ''
    # Ensure PEP 420 namespace package layout (split across trame-* packages)
    find trame -type f -name '__init__.py' -delete
  '';

  pythonImportsCheck = [
    "trame_vuetify"
    "trame_vuetify.module"
    "trame_vuetify.ui"
    "trame_vuetify.widgets"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vuetify widgets for trame";
    homepage = "https://github.com/Kitware/trame-vuetify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
