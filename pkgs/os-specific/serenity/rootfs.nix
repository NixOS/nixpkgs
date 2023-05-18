{ lib
, stdenv
, callPackage
, runCommand
, pkgsBuildBuild
, buildPackages
, src
, version
}:

let
  cpuArch = stdenv.targetPlatform.parsed.cpu.name;
in
stdenv.mkDerivation rec {
  inherit src version;
  pname = "serenity-rootfs";

  postPatch = ''
    substituteInPlace Toolchain/CMake/GNUToolchain.txt.in \
      --replace "gcc-ar" "ar" \
      --replace "gcc-nm" "nm" \
      --replace "gcc-ranlib" "ranlib"
    echo "" > Userland/Libraries/LibC/stubs.cpp
    echo "" > Tests/LibELF/CMakeLists.txt
  '';

  depsBuildBuild =
    [
      buildPackages.stdenv.cc
      pkgsBuildBuild.cmake
      pkgsBuildBuild.ninja
    ]
    ++ lib.optional stdenv.buildPlatform.isLinux buildPackages.libxcrypt;

  # The default cmake configure phase sets CMAKE_INSTALL_* flags that interfere
  # with expected paths
  dontUseCmakeConfigure = true;
  configurePhase = ''
    runHook preConfigure

    mkdir -p Toolchain/Local
    ln -s ${stdenv.cc} Toolchain/Local/${cpuArch}

    cmake -S Meta/CMake/Superbuild -B Build/superbuild-${cpuArch} -GNinja \
      -DCMAKE_C_COMPILER=gcc \
      -DCMAKE_CXX_COMPILER=g++ \
      -DSERENITY_ARCH=${cpuArch} \
      -DSERENITY_TOOLCHAIN=GNU \
      -DENABLE_TIME_ZONE_DATABASE_DOWNLOAD=OFF \
      -DENABLE_UNICODE_DATABASE_DOWNLOAD=OFF \
      -DENABLE_PCI_IDS_DOWNLOAD=OFF \
      -DENABLE_USB_IDS_DOWNLOAD=OFF \
      -DENABLE_PNP_IDS_DOWNLOAD=OFF \
      -DENABLE_CACERT_DOWNLOAD=OFF

    runHook postConfigure
  '';

  ninjaFlagsArray = [ "-CBuild/superbuild-${cpuArch}" ];
  enableParallelBuilding = true;

  # Build system uses --sysroot=Build/<arch>/Root to specify location of crt
  # libraries but the flag is unsupported in nixpkgs's ld-wrapper. Use -B as
  # a workaround
  preBuild = ''
    export NIX_CFLAGS_COMPILE+=" -B$(pwd)/Build/${cpuArch}/Root/usr/lib/"
  '';
  hardeningDisable = [ "fortify" ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r Build/${cpuArch}/Root/usr/{lib,include} $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Graphical Unix-like operating system for desktop computers";
    homepage = "https://serenityos.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.serenity;
  };
}
