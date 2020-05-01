{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "intermodal";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "05wjzx1ibd7cyl5lgmmn5y8dhsk71wz2bnimbmq7z51ds6cbyw5i";
  };

  cargoSha256 = "04xqk1mmbrz8bjn36nxabwla3y62wfdly5bckkya6y2dhf1vkdjq";

  # include_hidden test tries to use `chflags` on darwin
  checkFlagsArray = stdenv.lib.optionals stdenv.isDarwin [ "--skip=subcommand::torrent::create::tests::include_hidden" ];

  meta = with stdenv.lib; {
    description = "User-friendly and featureful command-line BitTorrent metainfo utility";
    homepage = "https://github.com/casey/intermodal";
    license = licenses.cc0;
    maintainers = with maintainers; [ filalex77 ];
  };
}
