{ callPackage, openssl_3_0, ... }@args:

callPackage ./generic.nix (args // { openssl = openssl_3_0; }) {
  version = "1.21.4";
  sha256 = "1ziv3xargxhxycd5hp6r3r5mww54nvvydiywcpsamg3i9r3jzxyi";
}
