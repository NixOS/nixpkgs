{ stdenv, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib }:

with ((import ./common.nix) { inherit stdenv; version = "2015-05-11"; });

with rustPlatform;

buildRustPackage rec {
  inherit name version meta;

  src = fetchgit {
    url = "https://github.com/rust-lang/cargo.git";
    rev = "a078e01ffab70738eafb7401704d1eaf90b94de2";
    sha256 = "0vw62kxlmkajyix6n4cdz7w9l26dspjiw2fk4xkj33gzzc8rq9g8";
    leaveDotGit = true;
  };

  depsSha256 = "1sk79w2wxvpgfkxr0nbrqqxdih4abiqvawdd88r2p9cqzrkdg8by";

  buildInputs = [ file curl pkgconfig python openssl cmake zlib ];

  configurePhase = ''
    ./configure --enable-optimize --prefix=$out --local-cargo=${cargo}/bin/cargo
  '';

  buildPhase = "make";

  # Disable check phase as there are lots of failures (some probably due to
  # trying to access the network).
  doCheck = false;

  installPhase = ''
    make install
    ${postInstall}
  '';
}
