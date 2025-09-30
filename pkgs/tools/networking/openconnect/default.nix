{
  callPackage,
  fetchFromGitLab,
}:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
rec {
  openconnect = common {
    version = "9.12-unstable-2025-01-14";
    src = fetchFromGitLab {
      owner = "openconnect";
      repo = "openconnect";
      rev = "f17fe20d337b400b476a73326de642a9f63b59c8";
      hash = "sha256-OBEojqOf7cmGtDa9ToPaJUHrmBhq19/CyZ5agbP7WUw=";
    };
  };

  openconnect_openssl = openconnect.override {
    useOpenSSL = true;
  };
}
