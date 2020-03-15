{ callPackage, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-lsp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "v${version}";

    sha256 = "0fy620c34kxl27sd62x9mj0555bcdmnmbsxavmyiwb497z1m9wnn";
  };

  cargoSha256 = "0xmaa7rds7hlagfxj65pv9vgflcv4nwbwbw4g7cyj88cbb1kbxxj";

  meta = with lib; {
    description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
