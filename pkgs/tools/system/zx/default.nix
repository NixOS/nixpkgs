{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "zx";
  version = "8.1.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    rev = version;
    hash = "sha256-oQL3EI4yTQOi+BM9ZkTILYulWD13Pof3JC1KVLSJWcA=";
  };

  npmDepsHash = "sha256-colrMoVN5uGVBeCvDfEU9tjjW9qkaiSKHPmTZ83EgCk=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for writing scripts using JavaScript";
    homepage = "https://github.com/google/zx";
    changelog = "https://github.com/google/zx/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlbribeiro ];
    mainProgram = "zx";
  };
}
