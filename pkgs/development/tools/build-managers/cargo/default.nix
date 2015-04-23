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

  cargoUpdateHook = ''
    # Updating because version 2.1.4 has an invalid Cargo.toml
    cargo update -p libressl-pnacl-sys --precise 2.1.5

    # Updating because version 0.1.3 has a build failure with recent rustc
    cargo update -p threadpool --precise 0.1.4
  '';

  depsSha256 = "12d2v4b85qabagrypvqiam2iybd4jwcg0sky0gqarfhjh2dhwfm6";

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
