{ stdenvNoCC
, lib
, fetchurl
, unzip
, dfVersion
}:

with lib;

let
  twbt-releases = {
    "0.44.10" = {
      twbtRelease = "6.49";
      sha256 = "1qjkc7k33qhxj2g18njzasccjqsis5y8zrw5vl90h4rs3i8ld9xz";
      prerelease = false;
    };
    "0.44.11" = {
      twbtRelease = "6.51";
      sha256 = "1yclqmarjd97ch054h425a12r8a5ailmflsd7b39cg4qhdr1nii5";
      prerelease = true;
    };
    "0.44.12" = {
      twbtRelease = "6.54";
      sha256 = "10gfd6vv0vk4v1r5hjbz7vf1zqys06dsad695gysc7fbcik2dakh";
      prerelease = false;
    };
    "0.47.02" = {
      twbtRelease = "6.61";
      sha256 = "07bqy9rkd64h033sxdpigp5zq4xrr0xd36wdr1b21g649mv8j6yw";
      prerelease = false;
    };
    "0.47.04" = {
      twbtRelease = "6.xx";
      dfhackRelease = "0.47.04-r5";
      sha256 = "sha256-+C3g4KJShCb2VXGQ4mtkDOufXZQ1P+ebDTmUzL3tNyU=";
      prerelease = true;
    };
    "0.47.05" = {
      twbtRelease = "6.xx";
      dfhackRelease = "0.47.05-r7";
      sha256 = "sha256-4xMKuSP5J6pMK+hwjTAcTI0gsLJfw+Xt+vh9CopR4tk=";
      prerelease = true;
    };
  };

  release =
    if hasAttr dfVersion twbt-releases
    then getAttr dfVersion twbt-releases
    else throw "[TWBT] Unsupported Dwarf Fortress version: ${dfVersion}";
in

stdenvNoCC.mkDerivation rec {
  pname = "twbt";
  version = release.twbtRelease;

  src = fetchurl {
    url =
      if version == "6.xx" then
        "https://github.com/thurin/df-twbt/releases/download/${release.dfhackRelease}/twbt-${version}-linux64-${release.dfhackRelease}.zip"
      else
        "https://github.com/mifki/df-twbt/releases/download/v${version}/twbt-${version}-linux.zip";
    sha256 = release.sha256;
  };

  sourceRoot = ".";

  outputs = [ "lib" "art" "out" ];

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $lib/hack/{plugins,lua} $art/data/art
    cp -a */twbt.plug.so $lib/hack/plugins/
    cp -a *.lua $lib/hack/lua/
    cp -a *.png $art/data/art/
  '';

  meta = with lib; {
    description = "A plugin for Dwarf Fortress / DFHack that improves various aspects the game interface.";
    maintainers = with maintainers; [ Baughn numinit ];
    license = licenses.mit;
    platforms = platforms.linux;
    homepage = "https://github.com/mifki/df-twbt";
  };
}
