{ fetchurl }:

let
  rev = "b362bd15f2ac7ce350d7563fc03e0c625e455e5f"; # should be the HEAD of nodejs/release-keys
in
fetchurl {
  url = "https://github.com/nodejs/release-keys/raw/${rev}/gpg-only-active-keys/pubring.kbx";
  hash = "sha256-ZnapJ9YmGnq2u03caWFII1Z0Jruax3ruSEz7XWb0oUg=";
}
