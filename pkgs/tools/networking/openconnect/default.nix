{
  callPackage,
  fetchurl,
  darwin,
}:
let
  common =
    opts:
    callPackage (import ./common.nix opts) {
      inherit (darwin.apple_sdk.frameworks) PCSC;
    };
in
rec {
  openconnect = common rec {
    version = "9.12";
    src = fetchurl {
      url = "ftp://ftp.infradead.org/pub/openconnect/openconnect-${version}.tar.gz";
      sha256 = "sha256-or7c46pN/nXjbkB+SOjovJHUbe9TNayVZPv5G9SyQT4=";
    };
  };

  openconnect_openssl = openconnect.override {
    useOpenSSL = true;
  };
}
