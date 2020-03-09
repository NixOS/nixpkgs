{ lib, rustPlatform, fetchFromGitLab, pkgconfig, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "scaff";
  version = "0.1.1";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = pname;
    rev = version;

    sha256 = "1s5v50205l2h33pccyafrjv3a6lpb62inhm8z81hkvx53bqifvd7";
  };

  cargoSha256 = "0k6msvly3yhzl1hhs4zv31qzbllwmw16i55dbznlgp1c8icy2pwr";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Painless and powerful scaffolding of projects";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
