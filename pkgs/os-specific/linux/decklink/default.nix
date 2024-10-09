{ stdenv
, lib
, blackmagic-desktop-video
, kernel
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "decklink";

  # the download is a horrible curl mess. we reuse it between the kernel module
  # and desktop service, since the version of the two have to match anyways.
  # See pkgs/by-name/bl/blackmagic-desktop-video/package.nix for more.
  inherit (blackmagic-desktop-video) src version;

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = placeholder "out";

  nativeBuildInputs =  kernel.moduleBuildDependencies;

  postUnpack = let
    arch = stdenv.hostPlatform.uname.processor;
  in ''
    tar xf Blackmagic_Desktop_Video_Linux_${lib.head (lib.splitString "a" finalAttrs.version)}/other/${arch}/desktopvideo-${finalAttrs.version}-${arch}.tar.gz
    moduleRoot=$NIX_BUILD_TOP/desktopvideo-${finalAttrs.version}-${stdenv.hostPlatform.uname.processor}/usr/src
    sourceRoot=$moduleRoot
  '';

  buildPhase = ''
    runHook preBuild
    make -C $moduleRoot/blackmagic-${finalAttrs.version} -j$NIX_BUILD_CORES
    make -C $moduleRoot/blackmagic-io-${finalAttrs.version} -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C $KERNELDIR M=$moduleRoot/blackmagic-${finalAttrs.version} modules_install
    make -C $KERNELDIR M=$moduleRoot/blackmagic-io-${finalAttrs.version} modules_install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    maintainers = [ maintainers.naxdy ];
    license = licenses.unfree;
    description = "Kernel module for the Blackmagic Design Decklink cards";
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
    platforms = platforms.linux;
  };
})
