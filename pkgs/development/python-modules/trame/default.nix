{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # build-system
  setuptools,

  # dependencies
  pyyaml,
  trame-server,
  trame-client,
  trame-common,
  wslink,
}:
buildPythonPackage (finalAttrs: {
  pname = "trame";
  version = "3.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame";
    hash = "sha256-iLhhFiy4sCXoTpPxfc/UOoTQLSwWCMn21Y481kalDAU=";
  };

  build-system = [ setuptools ];

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

  pythonImportsCheck = [ "trame" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Framework to build applications in plain Python";
    homepage = "https://github.com/Kitware/trame";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
