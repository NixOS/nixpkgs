{ lib, rustPlatform, fetchFromGitHub, nixVersions, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2023-08-09";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
    hash = "sha256-fZ8KfBMcIFO/R7xaWtB85SFeuUjb9SCH8fxYBnY8068=";
  };

  cargoHash = "sha256-lyKPmzuZB9rCBI9JxhxlyDtNHLia8FXGnSgV+D/dwgo=";

  nativeBuildInputs = [
    (lib.getBin nixVersions.unstable)
  ];

  env.CFG_RELEASE = version;

  # might be related to https://github.com/NixOS/nix/issues/5884
  preBuild = ''
    export NIX_STATE_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    changelog = "https://github.com/oxalica/nil/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda oxalica ];
    mainProgram = "nil";
  };
}
