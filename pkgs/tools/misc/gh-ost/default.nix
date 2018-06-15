{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

let
  goPackagePath = "github.com/github/gh-ost";
  version = "1.0.36";
  sha256 = "0qa7k50bf87bx7sr6iwqri8l49f811gs0bj3ivslxfibcs1z5d4h";

in {
  gh-ost = buildGoPackage ({
    name = "gh-ost-${version}";
    inherit goPackagePath;

    src = fetchFromGitHub {
      owner = "github";
      repo  = "gh-ost";
      rev   = "v${version}";
      inherit sha256;
    };

    meta = with stdenv.lib; {
      description = "Triggerless online schema migration solution for MySQL";
      homepage = https://github.com/github/gh-ost;
      license = licenses.mit;
      platforms = platforms.linux;
    };
  });
}
