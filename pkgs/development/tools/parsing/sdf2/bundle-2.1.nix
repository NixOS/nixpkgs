{stdenv, fetchurl, getopt, aterm}:

rec {

  errorsupport = (import ../error-support/error-support-0.1.nix) {
    inherit fetchurl stdenv aterm toolbuslib;
  };

  toolbuslib = (import ../toolbuslib/toolbuslib-0.6.nix) {
    inherit fetchurl stdenv aterm;
  };

  ptsupport = (import ../pt-support/pt-support-1.1.nix) {
    inherit fetchurl stdenv aterm toolbuslib errorsupport;
  };

  asfsupport = (import ../asf-support/asf-support-1.3.nix) {
    inherit fetchurl stdenv aterm ptsupport errorsupport;
  };

  sdfsupport = (import ../sdf-support/sdf-support-2.1.nix) {
    inherit fetchurl stdenv aterm toolbuslib ptsupport errorsupport;
  };

  sglr = (import ../sglr/sglr-3.11.nix) {
    inherit fetchurl stdenv aterm toolbuslib ptsupport errorsupport;
  };

  ascsupport = (import ../asc-support/asc-support-1.9.nix) {
    inherit fetchurl stdenv aterm toolbuslib ptsupport asfsupport errorsupport sglr;
  };

  pgen = (import ../pgen/pgen-2.1.nix) {
    inherit fetchurl stdenv getopt aterm toolbuslib ptsupport sdfsupport asfsupport ascsupport errorsupport sglr;
  };

  asflibrary = (import ../asf-library/asf-library-1.0.nix) {
    inherit fetchurl stdenv;
  };
}
