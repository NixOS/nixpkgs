{ lib
, stdenv
, fetchurl
, elfutils
, xorg
, patchelf
, libxcb
, libxshmfence
, perl
, zlib
, expat
, libffi
, libselinux
, libdrm
, udev
, kernel ? null
}:

with lib;

let

  bitness = if stdenv.is64bit then "64" else "32";

  libArch =
    if stdenv.hostPlatform.system == "i686-linux" then
      "i386-linux-gnu"
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      "x86_64-linux-gnu"
    else throw "amdgpu-pro is Linux only. Sorry.";

in stdenv.mkDerivation rec {

  version = "21.30";
  pname = "amdgpu-pro";
  build = "${version}-1290604";

  src = fetchurl {
    url = "https://drivers.amd.com/drivers/linux/amdgpu-pro-${build}-ubuntu-20.04.tar.xz";
    sha256 = "sha256-WECqxjo2WLP3kMWeVyJgYufkvHTzwGaj57yeMGXiQ4I=";
    curlOpts = "--referer https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-21-30";
  };

  postUnpack = ''
    mkdir root
    pushd $sourceRoot
    for deb in *_all.deb *_${if stdenv.is64bit then "amd64" else "i386"}.deb
    do
      ar p $deb data.tar.xz | tar -C ../root -xJ
    done
    popd
    # if we don't use a short sourceRoot, compilation can fail due to command
    # line length
    sourceRoot=root
  '';

  passthru = optionalAttrs (kernel != null) {
    kmod = stdenv.mkDerivation rec {
      inherit version src postUnpack;
      name = "${pname}-${version}-kmod-${kernel.dev.version}";

      postPatch = ''
        pushd usr/src/amdgpu-*
        patchShebangs amd/dkms/*.sh
        substituteInPlace amd/dkms/pre-build.sh --replace "./configure" "./configure --with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source --with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        popd
      '';

      preConfigure = ''
        pushd usr/src/amdgpu-*
        makeFlags="$makeFlags M=$(pwd)"
        amd/dkms/pre-build.sh ${kernel.version}
        popd
      '';

      postBuild = ''
        pushd usr/src/amdgpu-*
        find -name \*.ko -exec xz {} \;
        popd
      '';

      makeFlags = optionalString (kernel != null) "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build modules";

      installPhase = ''
        runHook preInstall

        pushd usr/src/amdgpu-*
        find -name \*.ko.xz -exec install -Dm444 {} $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/{} \;
        popd

        runHook postInstall
      '';

      # without this we get a collision with the ttm module from linux
      meta.priority = 4;
    };

    fw = stdenv.mkDerivation rec {
      inherit version src postUnpack;
      name = "${pname}-${version}-fw";

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib
        cp -r usr/src/amdgpu-*/firmware $out/lib/firmware

        runHook postInstall
      '';
    };
  };

  outputs = [ "out" "vulkan" ];

  depLibPath = makeLibraryPath [
    stdenv.cc.cc.lib
    zlib
    libxcb
    libxshmfence
    elfutils
    expat
    libffi
    libselinux
    # libudev is not listed in any dependencies, but is loaded dynamically
    udev
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    xorg.libXdamage
    xorg.libXxf86vm
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r usr/lib/${libArch} $out/lib
    cp -r usr/share $out/share

    mkdir -p $out/opt/amdgpu{,-pro}
    cp -r opt/amdgpu-pro/lib/${libArch} $out/opt/amdgpu-pro/lib
    cp -r opt/amdgpu/lib/${libArch} $out/opt/amdgpu/lib

    pushd $out/lib
    ln -s ../opt/amdgpu-pro/lib/libGL.so* .
    ln -s ../opt/amdgpu-pro/lib/libEGL.so* .
    popd

    # short name to allow replacement below
    ln -s lib/dri $out/dri

  '' + optionalString (stdenv.is64bit) ''
    mkdir -p $out/etc
    pushd etc
    cp -r modprobe.d udev amd $out/etc
    popd

    cp -r lib/udev/rules.d/* $out/etc/udev/rules.d
    cp -r opt/amdgpu/lib/xorg $out/lib/xorg
    cp -r opt/amdgpu-pro/lib/xorg/* $out/lib/xorg
    cp -r opt/amdgpu/share $out/opt/amdgpu/share
  '' + ''

    mkdir -p $vulkan/share/vulkan/icd.d
    install opt/amdgpu-pro/etc/vulkan/icd.d/amd_icd${bitness}.json $vulkan/share/vulkan/icd.d

    runHook postInstall
  '';

  preFixup = (if stdenv.is64bit
    # this could also be done with LIBGL_DRIVERS_PATH, but it would need to be
    # set in the user session and for Xorg
    then ''
      expr1='s:/opt/amdgpu/lib/x86_64-linux-gnu/dri\0:/run/opengl-driver/lib/dri\0\0\0\0\0\0\0\0\0\0\0:g'
      expr2='s:/usr/lib/x86_64-linux-gnu/dri[\0\:]:/run/opengl-driver/lib/dri\0\0\0\0:g'
      perl -pi -e "$expr2" $out/lib/xorg/modules/extensions/libglx.so
    ''
    else ''
      expr1='s:/opt/amdgpu/lib/i386-linux-gnu/dri\0:/run/opengl-driver-32/lib/dri\0\0\0\0\0\0:g'
      # we replace a different path on 32-bit because it's the only one long
      # enough to fit the target path :(
      expr2='s:/usr/lib/i386-linux-gnu/dri[\0\:]:/run/opengl-driver-32/dri\0\0\0:g'
    '') + ''
    perl -pi -e "$expr1" \
      $out/opt/amdgpu/lib/libEGL.so.1.0.0 \
      $out/opt/amdgpu/lib/libgbm.so.1.0.0 \
      $out/opt/amdgpu/lib/libGL.so.1.2.0

    perl -pi -e "$expr2" \
      $out/opt/amdgpu-pro/lib/libEGL.so.1 \
      $out/opt/amdgpu-pro/lib/libGL.so.1.2 \
      $out/opt/amdgpu-pro/lib/libGLX_amd.so.0

    find $out -type f -exec perl -pi -e 's:/opt/amdgpu-pro/:/run/amdgpu-pro/:g' {} \;
    find $out -type f -exec perl -pi -e 's:/opt/amdgpu/:/run/amdgpu/:g' {} \;

    substituteInPlace $vulkan/share/vulkan/icd.d/*.json --replace /opt/amdgpu-pro/lib/${libArch} "$out/opt/amdgpu-pro/lib"
  '';

  # doing this in post because shrinking breaks things that dynamically load
  postFixup = ''
    libPath="$out/opt/amdgpu/lib:$out/opt/amdgpu-pro/lib:$depLibPath"
    find "$out" -name '*.so*' -type f -exec patchelf --set-rpath "$libPath" {} \;
  '';

  buildInputs = [
    libdrm
    patchelf
    perl
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "AMDGPU-PRO drivers";
    homepage =  "https://www.amd.com/en/support";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ corngood ];
  };
}
