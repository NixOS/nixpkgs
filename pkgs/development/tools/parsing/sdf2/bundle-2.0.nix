{stdenv, fetchurl, getopt, aterm}:

rec {

  toolbuslib = (import ../toolbuslib/toolbuslib-0.5.1.nix) {
    inherit fetchurl stdenv aterm;
  };

  ptsupport = (import ../pt-support/pt-support-1.0.nix) {
    inherit fetchurl stdenv aterm toolbuslib;
  };

  asfsupport = (import ../asf-support/asf-support-1.2.nix) {
    inherit fetchurl stdenv aterm ptsupport;
  };

  sdfsupport = (import ../sdf-support/sdf-support-2.0.nix) {
    inherit fetchurl stdenv aterm toolbuslib ptsupport;
  };

  sglr = (import ../sglr/sglr-3.10.2.nix) {
    inherit fetchurl stdenv aterm toolbuslib ptsupport;
  };

  ascsupport = (import ../asc-support/asc-support-1.8.nix) {
    inherit fetchurl stdenv aterm toolbuslib ptsupport asfsupport;
  };

  pgen = (import ../pgen/pgen-2.0.nix) {
    inherit fetchurl stdenv getopt aterm toolbuslib ptsupport sdfsupport asfsupport ascsupport sglr;
  };
}
