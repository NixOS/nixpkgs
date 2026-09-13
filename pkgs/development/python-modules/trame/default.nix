{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # build-system
  setuptools,
  wheel,

  # dependencies
  pyyaml,
  trame-server,
  trame-client,
  trame-common,
  wslink,
}:
buildPythonPackage (finalAttrs: {
  pname = "trame";
  version = "3.13.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame";
    hash = "sha256-mGjRwrzpga4sZutqFtOeKhTwQu7bEEdmYmbHU+yvP2Q=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    trame-server
    trame-client
    trame-common
    wslink
    pyyaml
  ];

  preBuild = ''
    # Ensure PEP 420 namespace package layout (split across trame-* packages)
    for d in trame trame/modules trame/ui trame/widgets; do
      rm "$d/__init__.py"
    done
  '';

  pythonImportsCheck = [
    "trame"
    "trame.app"
    "trame.assets"
    "trame.env"
    "trame.modules"
    "trame.tools"
    "trame.ui"
    "trame.utils"
    "trame.widgets"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Framework to build applications in plain Python";
    homepage = "https://github.com/Kitware/trame";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
