{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "intermodal";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mn0wm3bihn7ffqk0p79mb1hik54dbhc9diq1wh9ylpld2iqmz68";
  };

  cargoSha256 = "1bvs23rb25qdwbrygzq11p8cvck5lxjp9llvs1cjdh0qzr65jwla";

  # include_hidden test tries to use `chflags` on darwin
  checkFlagsArray = lib.optionals stdenv.isDarwin [ "--skip=subcommand::torrent::create::tests::include_hidden" ];

  meta = with lib; {
    description = "User-friendly and featureful command-line BitTorrent metainfo utility";
    homepage = "https://github.com/casey/intermodal";
    license = licenses.cc0;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "imdl";
  };
}
