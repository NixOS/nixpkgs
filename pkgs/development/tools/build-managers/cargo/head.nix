{ stdenv, callPackage, rustc, rustPlatform }:

callPackage ./generic.nix rec {
  version = "2016.06.07";
  srcRev = "3e70312a2a4ebedace131fc63bb8f27463c5db28";
  srcSha = "0nibzyfjkiqfnq0c00hhqvs856l5qls8wds252p97q5q92yvp40f";
  depsSha256 = "1xbb33aqnf5yyws6gjys9w8kznbh9rh6hw8mpg1hhq1ahipc2j1f";
  inherit rustc;
  inherit rustPlatform;
}
