{ lib, rustPlatform, fetchFromGitHub, nix, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2023-03-11";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
    hash = "sha256-5WEdrN+ABrNOdfQc2k2mf+fj+ZvZR1Dp/PtypEdlFWA=";
  };

  cargoHash = "sha256-ISkw0lhUKJG8nWUHcR93sLUFt5dDEyK7EORcOXEmVbE=";

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
