{ lib, fetchFromGitHub, rustPlatform, pkgconfig, openssl, systemd }:

rustPlatform.buildRustPackage rec {
  name        = "journaldriver-${version}";
  version     = "1.1.0";
  cargoSha256 = "03rq96hzv97wh2gbzi8sz796bqgh6pbpvdn0zy6zgq2f2sgkavsl";

  src = fetchFromGitHub {
    owner  = "tazjin";
    repo   = "journaldriver";
    rev    = "v${version}";
    sha256 = "0672iq6s9klb1p37hciyl7snbjgjw98kwrbfkypv07lplc5qcnrf";
  };

  buildInputs       = [ openssl systemd ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with lib; {
    description = "Log forwarder from journald to Stackdriver Logging";
    homepage    = "https://github.com/tazjin/journaldriver";
    license     = licenses.gpl3;
    maintainers = [ maintainers.tazjin ];
    platforms   = platforms.linux;
  };
}
