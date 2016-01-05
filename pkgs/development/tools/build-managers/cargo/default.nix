{ stdenv, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib, makeWrapper }:

with rustPlatform;

with ((import ./common.nix) {
  inherit stdenv rustc;
  version = "0.7.0";
});

buildRustPackage rec {
  inherit name version meta passthru;

  # Needs to use fetchgit instead of fetchFromGitHub to fetch submodules
  src = fetchgit {
    url = "git://github.com/rust-lang/cargo";
    rev = "refs/tags/${version}";
    sha256 = "139rv7d6mk31klbnccmn573i05ygjrnflag6c3qwc075i62yfmx6";
  };

  depsSha256 = "07p244bcw3aa1hfbsz6q89pyl8ypkw9zp1r8cvd131w890w9ab4b";

  buildInputs = [ file curl pkgconfig python openssl cmake zlib makeWrapper ];

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
