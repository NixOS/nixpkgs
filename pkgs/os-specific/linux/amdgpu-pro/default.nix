{ stdenv, fetchurl, elfutils
, xorg, patchelf, openssl, libdrm, udev
, libxcb, libxshmfence, epoxy, perl, zlib
, ncurses
, libsOnly ? false, kernel ? null
}:

assert (!libsOnly) -> kernel != null;

with stdenv.lib;

let

  kernelDir = if libsOnly then null else kernel.dev;

  bitness = if stdenv.is64bit then "64" else "32";

  libArch =
    if stdenv.hostPlatform.system == "i686-linux" then
      "i386-linux-gnu"
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      "x86_64-linux-gnu"
    else throw "amdgpu-pro is Linux only. Sorry. The build was stopped.";

  libReplaceDir = "/usr/lib/${libArch}";

  ncurses5 = ncurses.override { abiVersion = "5"; };

in stdenv.mkDerivation rec {

  version = "17.40";
  pname = "amdgpu-pro";
  build = "${version}-492261";

  libCompatDir = "/run/lib/${libArch}";

  name = pname + "-" + version + (optionalString (!libsOnly) "-${kernelDir.version}");

  src = fetchurl {
    url =
    "https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-${build}.tar.xz";
    sha256 = "1c073lp9cq1rc2mddky2r0j2dv9dd167qj02visz37vwaxbm2r5h";
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

  modulePatches = optionals (!libsOnly) ([
    ./patches/0001-fix-warnings-for-Werror.patch
    ./patches/0002-fix-sketchy-int-ptr-warning.patch
    ./patches/0003-disable-firmware-copy.patch
  ]);

  patchPhase = optionalString (!libsOnly) ''
    pushd usr/src/amdgpu-${build}
    for patch in $modulePatches
    do
      echo $patch
      patch -f -p1 < $patch || true
    done
    popd
  '';

  xreallocarray = ./xreallocarray.c;

  preBuild = optionalString (!libsOnly) ''
    pushd usr/src/amdgpu-${build}
    makeFlags="$makeFlags M=$(pwd)"
    patchShebangs pre-build.sh
    ./pre-build.sh ${kernel.version}
    popd
    pushd lib
    $CC -fPIC -shared -o libhack-xreallocarray.so $xreallocarray
    strip libhack-xreallocarray.so
    popd
  '';

  modules = [
    "amd/amdgpu/amdgpu.ko"
    "amd/amdkcl/amdkcl.ko"
    "ttm/amdttm.ko"
  ];

  postBuild = optionalString (!libsOnly)
    (concatMapStrings (m: "xz usr/src/amdgpu-${build}/${m}\n") modules);

  NIX_CFLAGS_COMPILE = "-Werror";

  makeFlags = optionalString (!libsOnly)
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build modules";

  depLibPath = makeLibraryPath [
    stdenv.cc.cc.lib xorg.libXext xorg.libX11 xorg.libXdamage xorg.libXfixes zlib
    xorg.libXxf86vm libxcb libxshmfence epoxy openssl libdrm elfutils udev ncurses5
  ];

  installPhase = ''
    mkdir -p $out

    cp -r etc $out/etc
    cp -r lib $out/lib

    pushd usr
    cp -r lib/${libArch}/* $out/lib
  '' + optionalString (!libsOnly) ''
    cp -r src/amdgpu-${build}/firmware $out/lib/firmware
  '' + ''
    cp -r share $out/share
    popd

    pushd opt/amdgpu-pro
  '' + optionalString (!libsOnly && stdenv.is64bit) ''
    cp -r bin $out/bin
  '' + ''
    cp -r include $out/include
    cp -r share/* $out/share
    cp -r lib/${libArch}/* $out/lib
  '' + optionalString (!libsOnly) ''
    mv lib/xorg $out/lib/xorg
  '' + ''
    popd

  '' + optionalString (!libsOnly)
    (concatMapStrings (m:
      "install -Dm444 usr/src/amdgpu-${build}/${m}.xz $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/${m}.xz\n") modules)
  + ''
    mv $out/etc/vulkan $out/share
    interpreter="$(cat $NIX_CC/nix-support/dynamic-linker)"
    libPath="$out/lib:$out/lib/gbm:$depLibPath"
  '' + optionalString (!libsOnly && stdenv.is64bit) ''
    for prog in clinfo modetest vbltest kms-universal-planes kms-steal-crtc modeprint amdgpu_test kmstest proptest; do
      patchelf --interpreter "$interpreter" --set-rpath "$libPath" "$out/bin/$prog"
    done
  '' + ''
    ln -s ${makeLibraryPath [ncurses5]}/libncursesw.so.5 $out/lib/libtinfo.so.5
  '';

  # we'll just set the full rpath on everything to avoid having to track down dlopen problems
  postFixup = assert (stringLength libReplaceDir == stringLength libCompatDir); ''
    libPath="$out/lib:$out/lib/gbm:$depLibPath"
    for lib in `find "$out/lib/" -name '*.so*' -type f`; do
      patchelf --set-rpath "$libPath" "$lib"
    done
    for lib in libEGL.so.1 libGL.so.1.2 ${optionalString (!libsOnly) "xorg/modules/extensions/libglx.so"} dri/amdgpu_dri.so libamdocl${bitness}.so; do
      perl -pi -e 's:${libReplaceDir}:${libCompatDir}:g' "$out/lib/$lib"
    done
    for lib in dri/amdgpu_dri.so libdrm_amdgpu.so.1.0.0 libgbm_amdgpu.so.1.0.0 libkms_amdgpu.so.1.0.0 libamdocl${bitness}.so; do
      perl -pi -e 's:/opt/amdgpu-pro/:/run/amdgpu-pro/:g' "$out/lib/$lib"
    done
    substituteInPlace "$out/share/vulkan/icd.d/amd_icd${bitness}.json" --replace "/opt/amdgpu-pro/lib/${libArch}" "$out/lib"
  '' + optionalString (!libsOnly) ''
    for lib in drivers/modesetting_drv.so libglamoregl.so; do
      patchelf --add-needed $out/lib/libhack-xreallocarray.so $out/lib/xorg/modules/$lib
    done
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
