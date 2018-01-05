{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "go-runewidth-${version}";
  version = "0.0.2+97311d9";
  goPackagePath = "github.com/mattn/go-runewidth.git";

  src = fetchgit {
    url = https://github.com/mattn/go-runewidth.git;
    rev = "97311d9f7767e3d6f422ea06661bc2c7a19e8a5d";
    sha256 = "0dxlrzn570xl7gb11hjy1v4p3gw3r41yvqhrffgw95ha3q9p50cg";
  };

  meta = {
    description = "Provides functions to get fixed width of the character or string";
    homepage = https://github.com/mattn/go-runewidth;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.rob ];
  };
}
