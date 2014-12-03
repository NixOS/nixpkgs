{ stdenv, fetchurl, fetchgit, zlib, pkgconfig, openssl, cmake, buildRustPackage }:

/* Cargo binary snapshot */

with ((import ./common.nix) { inherit stdenv fetchurl zlib; });

buildRustPackage {
  name = "cargo";
  src = fetchgit {
    url = "https://github.com/rust-lang/cargo.git";
    rev = "0881adf3eef5283bdfc006a23ea907b6529b0027";
    sha256 = "1a37p2v8ic7qzjf831j1ri11r1d9lnr1d0cjfmgw4xjrxghsljdb";
  };
  sha256 = "1w6nbz60n7dk3shnxyn864r0xhsdz3lvh1yw0226lwqvykxmnmyx";

  buildInputs = [ pkgconfig openssl cmake zlib ];

  # TODO: cargo-fetch as a hook?
  

} // { inherit meta; }
