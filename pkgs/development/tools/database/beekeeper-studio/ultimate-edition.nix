{ callPackage, stdenv, ... }:

let
  is_arm = stdenv.hostPlatform.isAarch64;
  arm_postfix = if is_arm then "-arm64" else "";

  pname = "beekeeper-studio-ultimate";
  version = "3.9.9";

  sha512 =
    if is_arm then "2pmigd5lnd38qympfq6lb7myzng446icqwbccf5152xy39ysbjm0gzrngw3w2p043ixd817v88w49ppcrmiwvxpgal4avpbsivhdbs0"
              else "16lzrhl6xfz803namg0linaayv27gmf31rpw30pg5q1w6pq5xkcbn0i6vmfzl4bnn3qpjri0adbvc34xa8i456di63mzn470yxy40rk"
  ;

  url = "https://github.com/beekeeper-studio/ultimate-releases/releases/download/v${version}/Beekeeper-Studio-Ultimate-${version}${arm_postfix}.AppImage";
in callPackage ./common.nix {
  inherit url sha512 pname version;
  internalName = "beekeeper-studio";
}
