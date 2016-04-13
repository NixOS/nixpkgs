{ stdenv, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib, makeWrapper }:

with rustPlatform;

with ((import ./common.nix) {
  inherit stdenv rustc;
  version = "0.8.0";
});

buildRustPackage rec {
  inherit name version meta passthru;

  # Needs to use fetchgit instead of fetchFromGitHub to fetch submodules
  src = fetchgit {
    url = "git://github.com/rust-lang/cargo";
    rev = "refs/tags/${version}";
    sha256 = "02z0b6hpygjjfbskg22ggrhdv2nasrgf8x1fd8y0qzg4krx2czlh";
  };

  depsSha256 = "1gwc5ygs3h8jxs506xmbj1xzaqpb3kmg3pkxg9j9yqy616jw6rcn";

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
