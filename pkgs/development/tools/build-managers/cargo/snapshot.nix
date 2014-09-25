{ stdenv, fetchurl, zlib }:

/* Cargo binary snapshot */

with ((import ./common.nix) { inherit stdenv fetchurl zlib; });

snapshot // { inherit meta; }
