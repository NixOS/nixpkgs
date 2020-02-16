{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = version;
    sha256 = "1aigwwv576ybb3x3fppq46kbvd3k4fc4w1hh2hkzyyic6fibwbpy";
  };

  sourceRoot = "source/b3sum";

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0qw7sr817lmj9xicc03cj1k49lwjwc1whllc7sj2g4c0nl2vndir";
  verifyCargoDeps = false;

  cargoPatches = [ ./add-cargo-lock.patch ];

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
