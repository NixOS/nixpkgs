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

  cargoSha256 = "0h9dhv165y7wl2ykwdc74ph8b3dh74almjmxd1myfr55m4l1bbhk";

  meta = with lib; {
    description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
