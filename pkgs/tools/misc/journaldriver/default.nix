{ lib, fetchgit, rustPlatform, pkg-config, openssl, systemd }:

rustPlatform.buildRustPackage rec {
  pname = "journaldriver";
  version = "5656.0.0";
  cargoSha256 = "0jxv7skqgkk2j28jzs0gqnic0pqbdpgy8ryhz613pn0cslgy1p5q";

  src = fetchgit {
    url = "https://code.tvl.fyi/depot.git:/ops/journaldriver.git";
    sha256 = "0bnf67k6pkw4rngn58b5zm19danr4sh2g6rfd4k5w2sa1lzqai04";

    # TVL revision r/5656; as of 2023-01-13 the revision tag is
    # unavailable through git, hence the pinned hash.
    rev = "4e191353228197ce548d63cb9955e53661244f9c";
  };

  buildInputs = [ openssl systemd ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Log forwarder from journald to Stackdriver Logging";
    homepage = "https://code.tvl.fyi/about/ops/journaldriver";
    license = licenses.gpl3;
    maintainers = [ maintainers.tazjin ];
    platforms = platforms.linux;
  };
}
