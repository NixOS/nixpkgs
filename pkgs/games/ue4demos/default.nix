{ stdenv, fetchurl, unzip, patchelf, xlibs, openal
/*
, withTappyChicken ? false
, withSwingNinja ? false
, withCardGame ? false
, withVehicleGame ? false
, withShootherGame ? false
, withStrategyGame ? false
, withBlackJack ? false
, withLandscapeMountains ? false
, withMatineeDemo ? false
, withElementalDemo ? false
, withEffectsCaveDemo ? false
, withRealisticRendering ? false
, withReflectionsSubway ? false
, withSciFiHallwayDemo ? false
, withMobileTempleDemo ? false
, withStylizedDemo ? false
, withBlueprintExamplesDemo ? false
*/
}:

assert stdenv.isLinux;

let
  buildDemo = { name, src }:
    stdenv.mkDerivation rec {
      inherit name src;

      buildInputs = [ unzip patchelf ];

      buildCommand =
      ''
        mkdir -p "$out"
        cd $out
        unzip $src

        interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)
        rpaths=${stdenv.gcc.gcc}/lib64:${xlibs.libXxf86vm}/lib:${openal}/lib
        binary=$(find . -executable -type f)
        patchelf \
          --set-interpreter $interpreter \
          --set-rpath $rpaths \
          "$binary"

        mkdir bin
        cd bin
        ln -s "$out/$binary" $(basename "$out/$binary")
      '';

      meta = {
        description = "Unreal Engine 4 Linux demos";
        homepage = https://wiki.unrealengine.com/Linux_Demos;
        platforms = stdenv.lib.platforms.linux;
        #license = stdenv.lib.licenses.unfree-redistributable;
      };
    };

in {
  stylized_demo = buildDemo rec {
    name = "ue4demos-stylized_demo";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/stylized_demo.zip";
      sha256 = "1676ridmj8rk4y4hbdscfnnka5l636av1xxl0qwvk236kq9j7v0l";
    };
  };
}

