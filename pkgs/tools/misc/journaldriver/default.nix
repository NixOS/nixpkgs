{ lib, fetchFromGitHub, rustPlatform, pkgconfig, openssl, systemd }:

rustPlatform.buildRustPackage rec {
  pname = "journaldriver";
  version     = "1.1.0";
  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0wmr0r54ar7gvhvhv76a49ap74lx8hl79bf73vc4f4xlj7hj303g";

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
