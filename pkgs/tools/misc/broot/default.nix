{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "broot-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "broot";
    rev = "v${version}";
    sha256 = "192qqlqym8lpskh6f7sf5fanybjwhdqs1cgl6mqm35763fa5jrdj";
  };

  cargoSha256 = "059iylnkjb7lxxs9v2b6h05nidwgcj6kqyhcq58lalkhb63srb1q";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://github.com/Canop/broot";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
