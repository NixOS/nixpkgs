{ stdenv, fetchurl, elfutils, mesa_noglu
, xorg, patchelf, openssl, libdrm, libudev
, libxcb, libxshmfence, epoxy, perl, zlib
, fetchFromGitHub, ncurses
, libsOnly ? false, kernel ? null
}:

assert (!libsOnly) -> kernel != null;

with stdenv.lib;

let

  kernelDir = if libsOnly then null else kernel.dev;

  inherit (mesa_noglu) driverLink;

  bitness = if stdenv.is64bit then "64" else "32";

  libArch =
    if stdenv.system == "i686-linux" then
      "i386-linux-gnu"
    else if stdenv.system == "x86_64-linux" then
      "x86_64-linux-gnu"
    else throw "amdgpu-pro is Linux only. Sorry. The build was stopped.";

  libReplaceDir = "/usr/lib/${libArch}";

  ncurses5 = ncurses.override { abiVersion = "5"; };

in stdenv.mkDerivation rec {

  version = "16.40";
  pname = "amdgpu-pro";
  build = "16.40-348864";

  libCompatDir = "/run/lib/${libArch}";

  name = pname + "-" + version + (optionalString (!libsOnly) "-${kernelDir.version}");

  src = fetchurl {
    url =
    "https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-${build}.tar.xz";
    sha256 = "1c06lx07irmlpmbmgb3qcgpzj6q6rimszrbbdrgz8kqnfpcv3mjr";
    curlOpts = "--referer http://support.amd.com/en-us/kb-articles/Pages/AMD-Radeon-GPU-PRO-Linux-Beta-Driver%e2%80%93Release-Notes.aspx";
  };

  hardeningDisable = [ "pic" "format" ];

  inherit libsOnly;

  postUnpack = ''
    cd $sourceRoot
    mkdir root
    cd root
    for deb in ../*_all.deb ../*_i386.deb '' + optionalString stdenv.is64bit "../*_amd64.deb" + ''; do echo $deb; ar p $deb data.tar.xz | tar -xJ; done
    sourceRoot=.
  '';

  modulePatches = [
    ./patches/0001-Find-correct-System.map.patch
    ./patches/0002-Fix-kernel-module-install-location.patch
    ./patches/0003-Add-Gentoo-as-build-option.patch
    ./patches/0004-Remove-extra-parameter-from-ttm_bo_reserve-for-4.7.0.patch
    ./patches/0005-Remove-first-param-from-drm_gem_object_lookup.patch
    ./patches/0006-Remove-vblank_disable_allowed-assignment.patch
    ./patches/0007-Fix-__drm_atomic_helper_connector_destroy_state-call.patch
    ./patches/0008-Change-seq_printf-format-for-64-bit-context.patch
    ./patches/0009-Fix-vblank-calls.patch
    ./patches/0010-Fix-crtc_gamma-functions-for-4.8.0.patch
    ./patches/0011-Fix-drm_atomic_helper_swap_state-for-4.8.0.patch
    ./patches/0012-Add-extra-flag-to-ttm_bo_move_ttm-for-4.8.0-rc2.patch
    ./patches/0013-Remove-dependency-on-System.map.patch
    ./patches/0014-disable-dal-by-default.patch
  ];

  patchPhase = optionalString (!libsOnly) ''
    pushd usr/src/amdgpu-pro-${build}
    for patch in $modulePatches
    do
      echo $patch
      patch -f -p1 < $patch || true
    done
    popd
  '';

  preBuild = optionalString (!libsOnly) ''
    makeFlags="$makeFlags M=$(pwd)/usr/src/amdgpu-pro-${build}"
  '';

  postBuild = optionalString (!libsOnly) ''
    xz usr/src/amdgpu-pro-${build}/amd/amdgpu/amdgpu.ko
  '';

  makeFlags = optionalString (!libsOnly)
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build modules";

  depLibPath = makeLibraryPath [
    stdenv.cc.cc.lib xorg.libXext xorg.libX11 xorg.libXdamage xorg.libXfixes zlib
    xorg.libXxf86vm libxcb libxshmfence epoxy openssl libdrm elfutils libudev ncurses5
  ];

  installPhase = ''
    mkdir -p $out

    cp -r etc $out/etc
    cp -r lib $out/lib

    pushd usr
    cp -r lib/${libArch}/* $out/lib
  '' + optionalString (!libsOnly) ''
    cp -r src/amdgpu-pro-${build}/firmware $out/lib/firmware
  '' + ''
    cp -r share $out/share
    popd

    pushd opt/amdgpu-pro
  '' + optionalString (!stdenv.is64bit) ''
    cp -r bin $out/bin
  '' + ''
    cp -r include $out/include
    cp -r lib/${libArch}/* $out/lib
  '' + optionalString (!libsOnly) ''
    mv lib/xorg $out/lib/xorg
  '' + ''
    popd

  '' + optionalString (!libsOnly) ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/amd/amdgpu/amdgpu.ko.xz
    cp usr/src/amdgpu-pro-${build}/amd/amdgpu/amdgpu.ko.xz $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/amd/amdgpu/amdgpu.ko.xz
  '' + ''
    mv $out/etc/vulkan $out/share
    interpreter="$(cat $NIX_CC/nix-support/dynamic-linker)"
    libPath="$out/lib:$out/lib/gbm:$depLibPath"
  '' + optionalString (!stdenv.is64bit) ''
    for prog in clinfo modetest vbltest kms-universal-planes kms-steal-crtc modeprint amdgpu_test kmstest proptest; do
      patchelf --interpreter "$interpreter" --set-rpath "$libPath" "$out/bin/$prog"
    done
  '' + ''
    ln -s libgbm.so.1.0.0 $out/lib/libgbm.so.1
    ln -s ${makeLibraryPath [ncurses5]}/libncursesw.so.5 $out/lib/libtinfo.so.5
  '';

  # we'll just set the full rpath on everything to avoid having to track down dlopen problems
  postFixup = assert (stringLength libReplaceDir == stringLength libCompatDir); ''
    libPath="$out/lib:$out/lib/gbm:$depLibPath"
    for lib in `find "$out/lib/" -name '*.so*' -type f`; do
      patchelf --set-rpath "$libPath" "$lib"
    done
    for lib in libEGL.so.1 libGL.so.1.2 ${optionalString (!libsOnly) "xorg/modules/extensions/libglx.so"} dri/amdgpu_dri.so; do
      perl -pi -e 's:${libReplaceDir}:${libCompatDir}:g' "$out/lib/$lib"
    done
    substituteInPlace "$out/share/vulkan/icd.d/amd_icd${bitness}.json" --replace "/opt/amdgpu-pro/lib/${libArch}" "$out/lib"
  '';

  buildInputs = [
    patchelf
    perl
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "AMDGPU-PRO drivers";
    homepage =  http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Beta-Driver-for-Vulkan-Release-Notes.aspx ;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ corngood ];
    # Copied from the nvidia default.nix to prevent a store collision.
    priority = 4;
  };
}
