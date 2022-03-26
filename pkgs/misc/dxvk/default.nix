{ lib
, pkgs
, stdenv
, fetchFromGitHub
, pkgsCross
}:

let
  # DXVK needs to be a separate derivation because it’s actually a set of DLLs for Windows that
  # needs to be built with a cross-compiler.
  dxvk32 = pkgsCross.mingw32.callPackage ./dxvk.nix { inherit (self) src version dxvkPatches; };
  dxvk64 = pkgsCross.mingwW64.callPackage ./dxvk.nix { inherit (self) src version dxvkPatches; };

  # Use the self pattern to support overriding `src` and `version` via `overrideAttrs`. A recursive
  # attrset wouldn’t work.
  self = stdenv.mkDerivation {
    name = "dxvk";
    version = "1.10";

    src = fetchFromGitHub {
      owner = "doitsujin";
      repo = "dxvk";
      rev = "v${self.version}";
      hash = "sha256-/zH6vER/6s/d+Tt181UJOa97sqdkJyKGw6E36+1owzQ=";
    };

    # Patch DXVK to work with MoltenVK even though it doesn’t support some required features.
    # Some games will work poorly (particularly Unreal Engine 4 games), but others work pretty well.
    # Override this to patch DXVK itself (rather than the setup script).
    dxvkPatches = lib.optional stdenv.isDarwin ./darwin-dxvk-compat.patch;

    outputs = [ "out" "bin" "lib" ];

    # Also copy `mcfgthread-12.dll` due to DXVK’s being built in a MinGW cross environment.
    patches = [ ./mcfgthread.patch ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin $bin $lib
      substitute setup_dxvk.sh $out/bin/setup_dxvk.sh \
        --subst-var-by mcfgthreads32 "${pkgsCross.mingw32.windows.mcfgthreads}" \
        --subst-var-by mcfgthreads64 "${pkgsCross.mingwW64.windows.mcfgthreads}" \
        --replace 'basedir=$(dirname "$(readlink -f $0)")' "basedir=$bin"
      chmod a+x $out/bin/setup_dxvk.sh
      declare -A dxvks=( [x32]=${dxvk32} [x64]=${dxvk64} )
      for arch in "''${!dxvks[@]}"; do
        ln -s "''${dxvks[$arch]}/bin" $bin/$arch
        ln -s "''${dxvks[$arch]}/lib" $lib/$arch
      done
    '';

    # DXVK with MoltenVK requires a patched MoltenVK in addition to its own patches. Provide a
    # convenience function to handle the necessary patching.
    # Usage:
    # let
    #   patchedMoltenVK = dxvk.patchMoltenVK darwin.moltenvk;
    # in
    # wine64Packages.full.override { moltenvk = patchedMoltenVK; vkd3dSupport = false; }
    passthru.patchMoltenVK = moltenvk:
      moltenvk.overrideAttrs (old: {
        patches = old.patches or [ ] ++ [
          # Lie to DXVK about certain features that DXVK expects to be available and set defaults
          # for better performance/compatability on certain hardware.
          ./darwin-moltenvk-compat.patch
        ];
      });

    meta = {
      description = "A Vulkan-based translation layer for Direct3D 9/10/11";
      homepage = "https://github.com/doitsujin/dxvk";
      changelog = "https://github.com/doitsujin/dxvk/releases";
      maintainers = [ lib.maintainers.reckenrode ];
      license = lib.licenses.zlib;
      platforms = lib.platforms.unix;
    };
  };
in
self
