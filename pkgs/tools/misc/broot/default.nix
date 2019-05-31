{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pwbz4ac2zb40g6q6ykzhzfbn0jr5xarkvgw9wxv455mbi67rd6y";
  };

  cargoSha256 = "0cq78im3hg7wns260gwvajikj80l7kjbg3zycy3nvdx34llgv0n5";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
