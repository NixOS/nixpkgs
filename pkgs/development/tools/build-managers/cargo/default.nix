{ stdenv, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib }:

with ((import ./common.nix) { inherit stdenv; version = "2015-05-13"; });

with rustPlatform;

buildRustPackage rec {
  inherit name version meta;

  src = fetchgit {
    url = "https://github.com/rust-lang/cargo.git";
    rev = "d814fcbf8efda3027d54c09e11aa7eaf0006a83c";
    sha256 = "1hvsxjv9s30qylcq2vb2nqqn8fix4sk0ah718f8c0flrcqbwa58z";
    leaveDotGit = true;
  };

  depsSha256 = "0s9f00kg7q9dxd8g98k3z4qv404p9ra73l1bzxs6qzk54qhg44dp";

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
