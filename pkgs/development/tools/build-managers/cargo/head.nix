{ stdenv, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib, makeWrapper }:

with rustPlatform;

with ((import ./common.nix) {
  inherit stdenv rustc;
  version = "2016-03-20";
});

buildRustPackage rec {
  inherit name version meta passthru;

  # Needs to use fetchgit instead of fetchFromGitHub to fetch submodules
  src = fetchgit {
    url = "git://github.com/rust-lang/cargo";
    rev = "7d79da08238e3d47e0bc4406155bdcc45ccb8c82";
    sha256 = "190qdii53s4vk940yzs2iizhfs22y2v8bzw051bl6bk9bs3y4fdd";
  };

  depsSha256 = "1xbb33aqnf5yyws6gjys9w8kznbh9rh6hw8mpg1hhq1ahipc2j1f";

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
