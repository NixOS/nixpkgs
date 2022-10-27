{ lib
, pkgs
, hostPlatform
, stdenvNoCC
, fetchFromGitHub
, pkgsCross
}:

stdenvNoCC.mkDerivation (finalAttrs:
  let
    inherit (hostPlatform.uname) system;
    # DXVK needs to be a separate derivation because it’s actually a set of DLLs for Windows that
    # needs to be built with a cross-compiler.
    dxvk32 = pkgsCross.mingw32.callPackage ./dxvk.nix {
      inherit (finalAttrs) src version dxvkPatches;
    };
    dxvk64 = pkgsCross.mingwW64.callPackage ./dxvk.nix {
      inherit (finalAttrs) src version dxvkPatches;
    };

    # Split out by platform to make maintenance easy in case supported versions on Darwin and other
    # platforms diverge (due to the need for Darwin-specific patches that would fail to apply).
    # Should that happen, set `darwin` to the last working `rev` and `hash`.
    srcs = rec {
      darwin = { inherit (default) rev hash version; };
      default = {
        rev = "v${finalAttrs.version}";
        hash = "sha256-T93ZylxzJGprrP+j6axZwl2d3hJowMCUOKNjIyNzkmE=";
        version = "1.10.3";
      };
    };
  in
  {
    name = "dxvk";
    inherit (srcs."${system}" or srcs.default) version;

    src = fetchFromGitHub {
      owner = "doitsujin";
      repo = "dxvk";
      inherit (srcs."${system}" or srcs.default) rev hash;
    };

    # Override this to patch DXVK itself (rather than the setup script).
    dxvkPatches = lib.optionals stdenvNoCC.isDarwin [
      # Patch DXVK to work with MoltenVK even though it doesn’t support some required features.
      # Some games work poorly (particularly Unreal Engine 4 games), but others work pretty well.
      ./darwin-dxvk-compat.patch
      # Use synchronization primitives from the C++ standard library to avoid deadlocks on Darwin.
      # See: https://www.reddit.com/r/macgaming/comments/t8liua/comment/hzsuce9/
      ./darwin-thread-primitives.patch
    ];

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

    meta = {
      description = "A Vulkan-based translation layer for Direct3D 9/10/11";
      homepage = "https://github.com/doitsujin/dxvk";
      changelog = "https://github.com/doitsujin/dxvk/releases";
      maintainers = [ lib.maintainers.reckenrode ];
      license = lib.licenses.zlib;
      platforms = [ "x86_64-darwin" "i686-linux" "x86_64-linux" ];
    };
  })
