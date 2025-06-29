{
  callPackage,
  fetchurl,
}:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
rec {
  openconnect = common {
    version = "9.12-unstable-2024-12-28";
    src = fetchurl {
      url = "https://gitlab.com/openconnect/openconnect/-/archive/3e36871d6dd3dc476b259a39fcb3925af4ca5c0d/openconnect-3e36871d6dd3dc476b259a39fcb3925af4ca5c0d.tar.gz";
      sha256 = "sha256-PILOO+lKjVbBMPsmttHIAXtqtackTpJ4aFMpFsIJ2PU=";
    };
  };

  openconnect_openssl = openconnect.override {
    useOpenSSL = true;
  };
}
