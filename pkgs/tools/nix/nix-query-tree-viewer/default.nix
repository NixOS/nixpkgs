{ lib, fetchFromGitHub, rustPlatform, glib, gtk3, wrapGAppsHook }:

rustPlatform.buildRustPackage rec {
  pname = "nix-query-tree-viewer";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "cdepillabout";
    repo  = "nix-query-tree-viewer";
    rev = "v${version}";
    sha256 = "0vjcllhgq64n7mwxvyhmbqd6fpa9lwrpsnggc1kdlgd14ggq6jj6";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
  ];

  cargoSha256 = "1i9sjs77v1c3lch93pzjgr1zl0k1mlwkdpf3zfp13hyjn6zpldnj";

  meta = with lib; {
    description = "GTK viewer for the output of `nix store --query --tree`";
    homepage    = "https://github.com/cdepillabout/nix-query-tree-viewer";
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ cdepillabout ];
    platforms   = platforms.unix;
  };
}
