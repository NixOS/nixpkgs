{ lib, rustPlatform, fetchFromGitHub, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-feature";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "Riey";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0Ski+LytE636HHduisYJJq3khRsaJJ4YhpmaU5On348=";
  };

  cargoSha256 = "sha256-PA/s/BrqUftdGc5Lvd0glL9Dr8GLX9pYMq6WRRUQwEk=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Allows conveniently modify features of crate";
    homepage = "https://github.com/Riey/cargo-feature";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ riey ];
  };
}

