{ lib
, stdenvNoCC
, fetchFromGitHub
, pkgsCross
, stdenv
, bash
}:

stdenvNoCC.mkDerivation (finalAttrs:
  let
    dxvk32 = if stdenv.isDarwin then pkgsCross.mingw32.dxvk_1 else pkgsCross.mingw32.dxvk_2;
    dxvk64 = if stdenv.isDarwin then pkgsCross.mingwW64.dxvk_1 else pkgsCross.mingwW64.dxvk_2;
  in
  {
    name = "dxvk";
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
        --subst-var-by mcfgthreads32 "${pkgsCross.mingw32.windows.mcfgthreads}" \
        --subst-var-by mcfgthreads64 "${pkgsCross.mingwW64.windows.mcfgthreads}"
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
