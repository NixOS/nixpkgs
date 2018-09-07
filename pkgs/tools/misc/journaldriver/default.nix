{ lib, fetchFromGitHub, rustPlatform, pkgconfig, openssl, systemd }:

rustPlatform.buildRustPackage rec {
  name        = "journaldriver-${version}";
  version     = "1.0.0";
  cargoSha256 = "04llhriwsrjqnkbjgd22nhci6zmhadclnd8r2bw5092gwdamf49k";

  src = fetchFromGitHub {
    owner  = "aprilabank";
    repo   = "journaldriver";
    rev    = "v${version}";
    sha256 = "1163ghf7dxxchyawdaa7zdi8ly2pxmc005c2k549larbirjjbmgc";
  };

  buildInputs       = [ openssl systemd ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with lib; {
    description = "Log forwarder from journald to Stackdriver Logging";
    homepage    = "https://github.com/aprilabank/journaldriver";
    license     = licenses.gpl3;
    maintainers = [ maintainers.tazjin ];
    platforms   = platforms.linux;
  };
}
