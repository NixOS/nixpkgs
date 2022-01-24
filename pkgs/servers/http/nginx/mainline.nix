{ callPackage, openssl_3_0, ... }@args:

callPackage ./generic.nix (args // { openssl = openssl_3_0; }) {
  version = "1.21.5";
  sha256 = "sha256-sg879TOlGKbw86eWff7thy0mjTHkzBIaAAEylgLdz7s=";
}
