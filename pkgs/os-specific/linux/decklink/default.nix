{ stdenv
, lib
, blackmagic-desktop-video
, kernel
}:

stdenv.mkDerivation rec {
  pname = "decklink";

  # the download is a horrible curl mess. we reuse it between the kernel module
  # and desktop service, since the version of the two have to match anyways.
  # See pkgs/tools/video/blackmagic-desktop-video/default.nix for more.
  inherit (blackmagic-desktop-video) src version;

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = placeholder "out";

  nativeBuildInputs =  kernel.moduleBuildDependencies;

  postUnpack = ''
    tar xf Blackmagic_Desktop_Video_Linux_${lib.versions.majorMinor version}/other/${stdenv.hostPlatform.uname.processor}/desktopvideo-${version}-${stdenv.hostPlatform.uname.processor}.tar.gz
    moduleRoot=$NIX_BUILD_TOP/desktopvideo-${version}-${stdenv.hostPlatform.uname.processor}/usr/src
  '';


  buildPhase = ''
    runHook preBuild

    make -C $moduleRoot/blackmagic-${version} -j$NIX_BUILD_CORES
    make -C $moduleRoot/blackmagic-io-${version} -j$NIX_BUILD_CORES

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make -C $KERNELDIR M=$moduleRoot/blackmagic-${version} modules_install
    make -C $KERNELDIR M=$moduleRoot/blackmagic-io-${version} modules_install

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    maintainers = [ maintainers.hexchen ];
    license = licenses.unfree;
    description = "Kernel module for the Blackmagic Design Decklink cards";
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
    platforms = platforms.linux;
  };
}
