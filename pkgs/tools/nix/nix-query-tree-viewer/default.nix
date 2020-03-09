{ stdenv, fetchFromGitHub, rustPlatform, glib, gtk3, wrapGAppsHook }:

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

  cargoSha256 = "1pbyi7knqmqxbpi3jhl492is9zkaxdpdnmbm11nqwc1nvvbjblzc";

  meta = with stdenv.lib; {
    description = "GTK viewer for the output of `nix store --query --tree`";
    homepage    = "https://github.com/cdepillabout/nix-query-tree-viewer";
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ cdepillabout ];
    platforms   = platforms.unix;
  };
}
