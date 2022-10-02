{ callPackage, fetchFromGitLab, fetchurl, darwin }:
let
  common = opts: callPackage (import ./common.nix opts) {
    inherit (darwin.apple_sdk.frameworks) PCSC;
  };
in rec {
  openconnect = common rec {
    version = "9.01";
    src = fetchurl {
      url = "ftp://ftp.infradead.org/pub/openconnect/openconnect-${version}.tar.gz";
      sha256 = "sha256-s9f6+DDpeTKZ1qQegdhM1KPieJwUjJ5ZjkWFAQCQ5Mc=";
    };
  };

  openconnect_unstable = common {
    version = "unstable-2022-03-14";
    src = fetchFromGitLab {
      owner = "openconnect";
      repo = "openconnect";
      rev = "a27a46f1362978db9723c8730f2533516b4b31b1";
      sha256 = "sha256-Kz98GHCyEcx7vUF+AXMLR7886+iKGKNwx1iRaYcH8ps=";
    };
  };

  openconnect_openssl = openconnect.override {
    useOpenSSL = true;
  };
}



