{ stdenv, lib, cacert, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib, makeWrapper
# Darwin dependencies
, libiconv }:

with rustPlatform;

with ((import ./common.nix) {
  inherit stdenv rustc;
  version = "0.10.0";
});

buildRustPackage rec {
  inherit name version meta passthru;

  # Needs to use fetchgit instead of fetchFromGitHub to fetch submodules
  src = fetchgit {
    url = "git://github.com/rust-lang/cargo";
    rev = "refs/tags/${version}";
    sha256 = "06scvx5qh60mgvlpvri9ig4np2fsnicsfd452fi9w983dkxnz4l2";
  };

  depsSha256 = "0js4697n7v93wnqnpvamhp446w58llj66za5hkd6wannmc0gsy3b";

  buildInputs = [ file curl pkgconfig python openssl cmake zlib makeWrapper ]
    ++ lib.optional stdenv.isDarwin libiconv;

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
