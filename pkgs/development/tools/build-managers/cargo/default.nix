{ stdenv, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib }:

with ((import ./common.nix) { inherit stdenv; version = "2015-04-14"; });

with rustPlatform;

buildRustPackage rec {
  inherit name version meta setupHook;

  src = fetchgit {
    url = "https://github.com/rust-lang/cargo.git";
    rev = "d49b44358ed800351647571144257d35ac0886cf";
    sha256 = "1kaims28237mvp1qpw2cfgb3684jr54ivkdag0lw8iv9xap4i35y";
    leaveDotGit = true;
  };

  depsSha256 = "1yi39asmnrya8w83jrjxym658cf1a5ffp8ym8502rqqvx30y0yx4";

  buildInputs = [ file curl pkgconfig python openssl cmake zlib ];

  configurePhase = ''
    ./configure --enable-optimize --prefix=$out --local-cargo=${cargo}/bin/cargo
  '';

  buildPhase = "make";

  installPhase = ''
    make install
    ${postInstall}
  '';
}
