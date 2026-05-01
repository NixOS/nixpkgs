{
  callPackage,
  fetchFromGitLab,
}:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
rec {
  openconnect = common {
    version = "9.12-unstable-2025-11-03";
    src = fetchFromGitLab {
      owner = "openconnect";
      repo = "openconnect";
      rev = "0dcdff87db65daf692dc323732831391d595d98d";
      hash = "sha256-AvowUEDkXvR+QkhJbZU759fZjIqj/mO8HjP2Ka3lH1U=";
    };
  };

  openconnect_openssl = openconnect.override {
    useOpenSSL = true;
  };
}
