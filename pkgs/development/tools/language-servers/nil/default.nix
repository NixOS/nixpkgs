{ lib, rustPlatform, fetchFromGitHub, nix, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2023-03-01";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
    hash = "sha256-HGd/TV8ZHVAVBx+ndrxAfS/Nz+VHOQjNWjtKkkgYkqA=";
  };

  cargoHash = "sha256-A6Go1OYAaoDvQtAcK5BL5Tz00iLPOft0VLH6usWtb9g=";

  CFG_RELEASE = version;

  nativeBuildInputs = [
    (lib.getBin nix)
  ];

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
  };
}
