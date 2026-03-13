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
  pname = "trame-vuetify";
  version = "3.2.1";
  pyproject = true;
  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame_vuetify";
    hash = "sha256-FXiQSo/FMTuoAzB26i2TOKBQomxozuuyB/trFeGMCkU=";
  };

  build-system = [ setuptools ];

  dependencies = [ trame-client ];

  postPatch = ''
    # Ensure PEP 420 namespace package layout (split across trame-* packages)
    find trame -type f -name '__init__.py' -delete
  '';

  pythonImportsCheck = [ "trame_vuetify" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vuetify widgets for trame";
    homepage = "https://github.com/Kitware/trame-vuetify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
