{ callPackage, lib, path, fetchFromGitHub }:

let
  rev = "92034401b5291070a93ede030e718bb82b5e6da4";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixops";
    inherit rev;
    sha256 = "139mmf8ag392w5mn419k7ajp3pgcz6q349n7vm7gsp3g4sck2jjn";
  };

  nixopsSrc = {
    outPath = src;
    revCount = 0;
    shortRev = lib.substring 0 6 rev;
    inherit rev;
  };

  officialRelease = false;

  release = import (src + "/release.nix") {
    inherit nixopsSrc;
    inherit officialRelease;
    nixpkgs = path;
  };

  version = "1.6" + (
    if officialRelease
    then ""
    else "pre${toString nixopsSrc.revCount}_${nixopsSrc.shortRev}"
  );

  releaseName = "nixops-${version}";

in callPackage ./generic.nix {
  inherit version;
  src = release.tarball + "/tarballs/${releaseName}.tar.bz2";
}
