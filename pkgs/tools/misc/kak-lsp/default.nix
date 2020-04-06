{ stdenv, lib, darwin, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "ul";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b9v417g0z9q1sqgnms5vy740xggg4fcz0fdwbc4hfvfj6jkyaad";
  };

  cargoSha256 = "1cmms8kvh24sjb0w77i1bwl09wkx3x65p49pkg1j0lipwic3apm3";

  buildInputs = lib.optional stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = https://github.com/ul/kak-lsp;
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
    platforms = platforms.all;
  };
}
