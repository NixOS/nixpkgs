{ callPackage, stdenv }:

let
  is_arm = stdenv.hostPlatform.isAarch64;
  arm_postfix = if is_arm then "-arm64" else "";

  pname = "beekeeper-studio";
  version = "3.9.9";

  sha512 =
    if is_arm then "3hw829csgv2r2yydfazlf74s6cnwi7zaifkgpllyjd762k5xk7h73xfl33aagldn4gbwp1cqfx80f0kglz194mgggr85rylfg9xhv8x"
              else "22vxrczdqrklj0q3wlxcws4afnwpcp9cn1fpdl6flwlcsrgvk9n522g3852zg6f52wycf65bq434kb78dk3yc85578zdylm42jhdhr7"
  ;

  url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/Beekeeper-Studio-${version}${arm_postfix}.AppImage";
in callPackage ./common.nix { inherit url sha512 pname version; }
