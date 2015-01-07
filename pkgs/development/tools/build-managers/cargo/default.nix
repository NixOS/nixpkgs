{ stdenv, fetchurl, fetchgit, file, curl, zlib, python, pkgconfig, openssl, cmake, rustc, fetchCargoDeps }:

with ((import ./common.nix) { inherit stdenv fetchurl zlib; });

stdenv.mkDerivation rec {
  name = "cargo";
  src = fetchgit {
    url = "https://github.com/rust-lang/cargo.git";
    rev = "70f5205dba9887d8dab07f72dbc507aa74b12c1f";
    sha256 = "adb72daa9cba480e81e9c00aff3aa5f77e9c11fd10cd958b9d2eeb12cfaa60fe";
  };

  cargoDeps = fetchCargoDeps {
    src = src;
    sha256 = "0cnpk04raiaqwygwliaqfqwv0yvkcfsxmv6q8iflnl3hqpf88g6y";
  };

  buildInputs = [ file curl pkgconfig python openssl cmake zlib rustc snapshot ];

  configurePhase = "./configure --local-cargo=${snapshot}/bin/cargo";
  buildPhase = "cargo build --verbose";

} // { inherit meta; }
