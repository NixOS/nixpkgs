{ lib
, stdenvNoCC
, fetchFromGitHub
, pkgsCross
, stdenv
, bash
}:

stdenvNoCC.mkDerivation (finalAttrs:
  let
<<<<<<< HEAD
    dxvk32 = if stdenv.isDarwin
      then pkgsCross.mingw32.dxvk_1.override { enableMoltenVKCompat = true; }
      else pkgsCross.mingw32.dxvk_2;
    dxvk64 = if stdenv.isDarwin
      then pkgsCross.mingwW64.dxvk_1.override { enableMoltenVKCompat = true; }
      else pkgsCross.mingwW64.dxvk_2;
=======
    dxvk32 = if stdenv.isDarwin then pkgsCross.mingw32.dxvk_1 else pkgsCross.mingw32.dxvk_2;
    dxvk64 = if stdenv.isDarwin then pkgsCross.mingwW64.dxvk_1 else pkgsCross.mingwW64.dxvk_2;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  in
  {
    pname = "dxvk";
    inherit (dxvk64) version;

    outputs = [ "out" "bin" "lib" ];

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin $bin $lib
      substitute ${./setup_dxvk.sh} $out/bin/setup_dxvk.sh \
        --subst-var-by bash ${bash} \
        --subst-var-by dxvk32 ${dxvk32} \
        --subst-var-by dxvk64 ${dxvk64} \
<<<<<<< HEAD
        --subst-var-by mcfgthreads32 "${pkgsCross.mingw32.windows.mcfgthreads_pre_gcc_13}" \
        --subst-var-by mcfgthreads64 "${pkgsCross.mingwW64.windows.mcfgthreads_pre_gcc_13}"
=======
        --subst-var-by mcfgthreads32 "${pkgsCross.mingw32.windows.mcfgthreads}" \
        --subst-var-by mcfgthreads64 "${pkgsCross.mingwW64.windows.mcfgthreads}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      chmod a+x $out/bin/setup_dxvk.sh
      declare -A dxvks=( [x32]=${dxvk32} [x64]=${dxvk64} )
      for arch in "''${!dxvks[@]}"; do
        ln -s "''${dxvks[$arch]}/bin" $bin/$arch
        ln -s "''${dxvks[$arch]}/lib" $lib/$arch
      done
    '';

    meta = {
      description = "Setup script for DXVK";
      homepage = "https://github.com/doitsujin/dxvk";
      changelog = "https://github.com/doitsujin/dxvk/releases";
      maintainers = [ lib.maintainers.reckenrode ];
      license = lib.licenses.zlib;
      platforms = [ "x86_64-darwin" "i686-linux" "x86_64-linux" ];
    };
  })
