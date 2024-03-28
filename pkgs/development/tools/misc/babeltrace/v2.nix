{ callPackage
}:

callPackage ./common.nix
{
  version = "2.0.5";
  hash = "sha256-8jY+zOI1Xqht9ybVDPelJgKrGTheIuzGaiaGV3dGJ+4=";
}
{
  pname = "babeltrace2";

  preBuild = ''
    makeFlagsArray+=(CFLAGS="-Wno-error=stringop-truncation -Wno-error=null-dereference")
  '';
}
