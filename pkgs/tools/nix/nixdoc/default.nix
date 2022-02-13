{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tazjin";
    repo  = "nixdoc";
    rev = "v${version}";
    sha256 = "14d4dq06jdqazxvv7fq5872zy0capxyb0fdkp8qg06gxl1iw201s";
  };

  buildInputs =  lib.optionals stdenv.isDarwin [ darwin.Security ];

  cargoSha256 = "1nv6g8rmjjbwqmjkrpqncypqvx5c7xp2zlx5h6rw2j9d1wlys0v5";

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    homepage    = "https://github.com/tazjin/nixdoc";
    license     = [ licenses.gpl3 ];
    maintainers = [ maintainers.tazjin ];
    platforms   = platforms.unix;
  };
}
