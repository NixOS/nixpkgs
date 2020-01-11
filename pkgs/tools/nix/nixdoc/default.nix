{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tazjin";
    repo  = "nixdoc";
    rev = "v${version}";
    sha256 = "14d4dq06jdqazxvv7fq5872zy0capxyb0fdkp8qg06gxl1iw201s";
  };

  buildInputs =  stdenv.lib.optional stdenv.isDarwin [ darwin.Security ];

  cargoSha256 = "1hy8w73fir4wnqx7zfvfqh7s24w95x9nkw55kmizvrwf0glw9m4n";

  meta = with stdenv.lib; {
    description = "Generate documentation for Nix functions";
    homepage    = https://github.com/tazjin/nixdoc;
    license     = [ licenses.gpl3 ];
    maintainers = [ maintainers.tazjin ];
    platforms   = platforms.unix;
  };
}
