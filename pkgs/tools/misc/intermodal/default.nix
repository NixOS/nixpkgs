{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "intermodal";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mn0wm3bihn7ffqk0p79mb1hik54dbhc9diq1wh9ylpld2iqmz68";
  };

  cargoSha256 = "0kf5afarfwcl47b40pwnslfvxmxllmb995vc5ls2lpz4cx0jwahn";

  # include_hidden test tries to use `chflags` on darwin
  checkFlagsArray = stdenv.lib.optionals stdenv.isDarwin [ "--skip=subcommand::torrent::create::tests::include_hidden" ];

  meta = with stdenv.lib; {
    description = "User-friendly and featureful command-line BitTorrent metainfo utility";
    homepage = "https://github.com/casey/intermodal";
    license = licenses.cc0;
    maintainers = with maintainers; [ filalex77 ];
  };
}
