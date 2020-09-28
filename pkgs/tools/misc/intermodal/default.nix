{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "intermodal";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wqf227ljfys16jfbxi6mlkgdczgqrh15ixl9vi6higlxfi2wsj2";
  };

  cargoSha256 = "0lx8y1y5mf8ga7iz74dnfyf2b9jx15wishw0khfxknmh96h2y99h";

  # include_hidden test tries to use `chflags` on darwin
  checkFlagsArray = stdenv.lib.optionals stdenv.isDarwin [ "--skip=subcommand::torrent::create::tests::include_hidden" ];

  meta = with stdenv.lib; {
    description = "User-friendly and featureful command-line BitTorrent metainfo utility";
    homepage = "https://github.com/casey/intermodal";
    license = licenses.cc0;
    maintainers = with maintainers; [ filalex77 ];
  };
}
