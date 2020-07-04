{ lib, fetchFromGitHub, rustPlatform, pkgconfig, openssl, systemd }:

rustPlatform.buildRustPackage rec {
  pname = "journaldriver";
  version     = "1.1.0";
  cargoSha256 = "1vyc9pglppfz5idahvcj01wpmmm6jw043zk896wdksywa5zcqn28";

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
