{ stdenv, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib }:

with ((import ./common.nix) { inherit stdenv; version = "0.3.0"; });

with rustPlatform;

buildRustPackage rec {
  inherit name version meta;

  src = fetchgit {
    url = "https://github.com/rust-lang/cargo.git";
    rev = "refs/tags/0.3.0";
    sha256 = "1ckb2xd7nm8357imw6b1ci2ar8grnihzan94kvmjrijq6sz8yv9i";
    leaveDotGit = true;
  };

  depsSha256 = "1sgdr2akd9xrfmf5g0lbf842b2pdj1ymxk37my0cf2x349rjsf0w";

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
