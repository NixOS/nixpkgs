{ stdenv, fetchurl, elfutils, mesa_noglu
, xorg, patchelf, openssl, libdrm, libudev
, libxcb, libxshmfence, epoxy, perl, zlib
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

in stdenv.mkDerivation rec {

  version = "16.30";
  pname = "amdgpu-pro";
  build = "16.30.3-315407";

  libCompatDir = "/run/lib/${libArch}";

  name = pname + "-" + version + (optionalString (!libsOnly) "-${kernelDir.version}");

  src = fetchurl {
    url =
    "https://www2.ati.com/drivers/linux/amdgpu-pro_${build}.tar.xz";
    sha256 = "97d6fb64617cf2cefe780e5fb83b29d8ee4e3e7886b71fe3d92b0113847b2354";
    curlOpts = "--referer http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Beta-Driver-for-Vulkan-Release-Notes.aspx";
  };

  hardeningDisable = [ "pic" "format" ];

  inherit libsOnly;

  postUnpack = ''
    cd $sourceRoot
    mkdir root
    cd root
    for deb in ../*.deb; do echo $deb; ar p $deb data.tar.xz | tar -xJ; done
    sourceRoot=.
  '';

  modulePatches = [
    ./patches/0001-add-OS-detection-for-arch.patch
    ./patches/0002-update-kcl_ttm_bo_reserve-for-linux-4.7.patch
    ./patches/0003-add-kcl_drm_gem_object_lookup.patch
    ./patches/0004-paging-changes-for-linux-4.6.patch
    ./patches/0005-LRU-stuff-isn-t-available-until-4.7.x.patch
    ./patches/0006-Change-name-of-vblank_disable_allowed-to-vblank_disa.patch
    ./patches/0007-Remove-connector-parameter-from-__drm_atomic_helper_.patch
    ./patches/0008-fix-apparent-typo-in-bandwidth_calcs-causing-array-e.patch
    ./patches/0009-disable-dal-by-default.patch
    ./patches/0010-remove-dependency-on-System.map.patch
  ];

  patchPhase = optionalString (!libsOnly) ''
    pushd usr/src/amdgpu-pro-${build}
    for patch in $modulePatches; do echo $patch; patch -p1 < $patch; done
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
    xorg.libXxf86vm libxcb libxshmfence epoxy openssl libdrm elfutils libudev
  ];

  installPhase = ''
    mkdir -p $out
    cp -r usr/bin $out/bin
    cp -r etc $out/etc
    cp -r usr/include $out/include
    cp -r usr/lib/${libArch} $out/lib
    mv $out/lib/amdgpu-pro/* $out/lib/
    rmdir $out/lib/amdgpu-pro
    cp -r usr/share $out/share
  '' + optionalString (!libsOnly) ''
    if [ -d $out/lib/xorg ]; then
      rm $out/lib/xorg
      mv $out/lib/1.18 $out/lib/xorg
      rm -r $out/lib/1.*
    fi
    cp -r lib/firmware $out/lib/firmware
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/amd/amdgpu/amdgpu.ko.xz
    cp usr/src/amdgpu-pro-${build}/amd/amdgpu/amdgpu.ko.xz $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/amd/amdgpu/amdgpu.ko.xz
  '' + ''
    interpreter="$(cat $NIX_CC/nix-support/dynamic-linker)"
    libPath="$out/lib:$out/lib/gbm:$depLibPath"
    echo patching with $interpreter $libPath
    for prog in "$out"/bin/*; do
      echo patching program $prog
      patchelf --interpreter "$interpreter" --set-rpath "$libPath" "$prog"
    done
    for lib in `find "$out/lib/" -name '*.so*'`; do
      echo patching library $lib
      patchelf --set-rpath "$libPath" "$lib"
    done
  '';

  postFixup = assert (stringLength libReplaceDir == stringLength libCompatDir); ''
    libPath="$out/lib:$out/lib/gbm:$depLibPath"
    for lib in libgbm.so.1.0.0 ${optionalString (!libsOnly) "xorg/modules/drivers/amdgpu_drv.so"} amdvlk${bitness}.so vdpau/libvdpau_amdgpu.so; do
      if [ -e "$out/lib/$lib" ]; then
        patchelf --set-rpath "$libPath" "$out/lib/$lib"
      fi
    done
    for lib in libEGL.so.1 libGL.so.1.2 ${optionalString (!libsOnly) "xorg/modules/extensions/libglx.so"} dri/amdgpu_dri.so; do
      if [ -e "$out/lib/$lib" ]; then
        perl -pi -e 's:${libReplaceDir}:${libCompatDir}:g' "$out/lib/$lib"
      fi
    done
    substituteInPlace "$out/etc/vulkan/icd.d/amd_icd${bitness}.json" --replace "/usr/lib/${libArch}" "$out/lib"
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
