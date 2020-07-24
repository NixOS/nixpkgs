{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = version;
    sha256 = "02yyv91wvy5w7i05z6f3kzxm5x34a4xgkgmcqxnb0ivsxnnld73h";
  };

  sourceRoot = "source/b3sum";

  cargoSha256 = "0ycn5788dc925wx28sgfs121w4x7yggm4mnmwij829ka8859bymk";

  cargoPatches = [ ./add-cargo-lock.patch ];

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
