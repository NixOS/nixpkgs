{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  nix-update-script,
  uv-build,
  langcodes,
}:

buildPythonPackage (finalAttrs: {
  pname = "unidata-blocks";
  version = "0.0.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "unidata-blocks";
    tag = finalAttrs.version;
    hash = "sha256-pGFZc1LeatyH1tB1JCijKYKovcjFafGB0G+2tUhHgYY=";
  };

  build-system = [ uv-build ];

  dependencies = [ langcodes ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unidata_blocks" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library that helps query unicode blocks by Blocks.txt";
    homepage = "https://github.com/TakWolf/unidata-blocks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
})
