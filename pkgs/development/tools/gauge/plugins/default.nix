{ lib, pkgs }:
lib.makeScope pkgs.newScope (final: {
  makeGaugePlugin = final.callPackage ./make-gauge-plugin.nix { };
  dotnet = final.callPackage ./dotnet { };
  html-report = final.callPackage ./html-report { };
  java = final.callPackage ./java { };
  js = final.callPackage ./js { };
  go = final.callPackage ./go { };
  ruby = final.callPackage ./ruby { };
})
