{
  lib,
  fetchFromGitHub,
  rustPlatform,
  glib,
  gtk3,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-query-tree-viewer";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "cdepillabout";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Lc9hfjybnRrkd7PZMa2ojxOM04bP4GJyagkZUX2nVwY=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
  ];

  cargoSha256 = "sha256-NSLBIvgo5EdCvZq52d+UbAa7K4uOST++2zbhO9DW38E=";

  meta = with lib; {
    description = "GTK viewer for the output of `nix store --query --tree`";
    mainProgram = "nix-query-tree-viewer";
    homepage = "https://github.com/cdepillabout/nix-query-tree-viewer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.unix;
  };
}
