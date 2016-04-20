{ stdenv, cacert, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib, makeWrapper }:

with rustPlatform;

with ((import ./common.nix) {
  inherit stdenv rustc;
  version = "0.9.0";
});

buildRustPackage rec {
  inherit name version meta passthru;

  # Needs to use fetchgit instead of fetchFromGitHub to fetch submodules
  src = fetchgit {
    url = "git://github.com/rust-lang/cargo";
    rev = "refs/tags/${version}";
    sha256 = "0d3n2jdhaz06yhilvmw3m2avxv501da1hdhljc9mwkz3l5bkv2jv";
  };

  depsSha256 = "1x2m7ww2z8nl5ic2nds85p7ma8x0zp654jg7ay905ia95daiabzg";

  buildInputs = [ file curl pkgconfig python openssl cmake zlib makeWrapper ];

  configurePhase = ''
    ./configure --enable-optimize --prefix=$out --local-cargo=${cargo}/bin/cargo
  '';

  buildPhase = "make";

  checkPhase = ''
    # Export SSL_CERT_FILE as without it one test fails with SSL verification error
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    # Disable cross compilation tests
    export CFG_DISABLE_CROSS_TESTS=1
    cargo test
  '';

  # Disable check phase as there are failures (author_prefers_cargo test fails)
  doCheck = false;

  installPhase = ''
    make install
    ${postInstall}
  '';
}
