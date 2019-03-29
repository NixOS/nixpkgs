{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qi29qy4kwqfbca5ghdmjidpwn2wghr19jwzrrk0xvlq1xb13jfa";
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
