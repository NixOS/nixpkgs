{ callPackage, openssl_3_0, ... }@args:

callPackage ./generic.nix (args // { openssl = openssl_3_0; }) {
  version = "1.21.6";
  sha256 = "1bh52jqqcaj5wlh2kvhxr00jhk2hnk8k97ki4pwyj4c8920p1p36";
}
