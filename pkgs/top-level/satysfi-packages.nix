{
  lib,
  pkgs,
}:
{
  base = pkgs.callPackage ../development/satysfi-packages/base { };
  fonts-dejavu = pkgs.callPackage ../development/satysfi-packages/fonts-dejavu { };
  fss = pkgs.callPackage ../development/satysfi-packages/fss { };
  test = pkgs.callPackage ../development/satysfi-packages/test { };
  zrbase = pkgs.callPackage ../development/satysfi-packages/zrbase { };
}
