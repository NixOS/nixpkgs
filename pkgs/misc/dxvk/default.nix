{ lib
, stdenvNoCC
, fetchFromGitHub
, pkgsOn
, stdenv
, bash
}:

stdenvNoCC.mkDerivation (finalAttrs:
  let
    dxvk32 = if stdenv.isDarwin
      then pkgsOn.i686.w64.windows.gnu.dxvk_1.override { enableMoltenVKCompat = true; }
      else pkgsOn.i686.w64.windows.gnu.dxvk_2;
    dxvk64 = if stdenv.isDarwin
      then pkgsOn.x86_64.w64.windows.gnu.dxvk_1.override { enableMoltenVKCompat = true; }
      else pkgsOn.x86_64.w64.windows.gnu.dxvk_2;
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
        --subst-var-by mcfgthreads32 "${pkgsOn.i686.w64.windows.gnu.windows.mcfgthreads_pre_gcc_13}" \
        --subst-var-by mcfgthreads64 "${pkgsOn.x86_64.w64.windows.gnu.windows.mcfgthreads_pre_gcc_13}"
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
