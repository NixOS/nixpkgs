{ stdenv, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib }:

with ((import ./common.nix) { inherit stdenv; version = "0.5.0"; });

with rustPlatform;

buildRustPackage rec {
  inherit name version meta;

  # Needs to use fetchgit instead of fetchFromGitHub to fetch submodules
  src = fetchgit {
    url = "git://github.com/rust-lang/cargo";
    rev = "refs/tags/${version}";
    sha256 = "1wg7vr6fpk9n76ly65lf2z9w1dj5nhykffbwrv46lybd8m3r8x3w";
  };

  depsSha256 = "1q92q63g9pz7fy9fhx8y0kqarsshmzv1dq18ki3hdd7d5pcbczna";

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
