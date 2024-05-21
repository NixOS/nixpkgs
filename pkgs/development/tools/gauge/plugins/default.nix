{ lib, pkgs }:
lib.makeScope pkgs.newScope (final: let
  inherit (final) callPackage;
in {
  makeGaugePlugin = callPackage ./make-gauge-plugin.nix { };
  dotnet = callPackage ./dotnet { };
  html-report = callPackage ./html-report { };
  java = callPackage ./java { };
  js = callPackage ./js { };
  ruby = callPackage ./ruby { };
  go = callPackage ./go { };
  screenshot = callPackage ./screenshot { };
  xml-report = callPackage ./xml-report { };
})
