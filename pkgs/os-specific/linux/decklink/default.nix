{ stdenv, lib, requireFile, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  pname = "decklink";
  version = "12.0a14";

  src = requireFile {
    name = "Blackmagic_Desktop_Video_Linux_${lib.versions.majorMinor version}.tar.gz";
    url = "https://www.blackmagicdesign.com/support/download/76b2edbed5884e1dbbfea104071f1643/Linux";
    sha256 = "e5a586ee705513cf5e6b024e1ec68621ab91d50b370981023e0bff73a19169c2";
  };

  patches = [
    (fetchpatch {
      name = "01-fix-get_user_pages.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/01-fix-get_user_pages.patch?h=decklink&id=212ec426d96db3de0fedad803238d0604cc4df76";
      sha256 = "193199d59kmwdajhyw9k98636lbxrxwnxwlbhhijp1qms6y1qn2j";
    })
    (fetchpatch {
      name = "02-fix-have_unlocked_ioctl.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/02-fix-have_unlocked_ioctl.patch?h=decklink&id=212ec426d96db3de0fedad803238d0604cc4df76";
      sha256 = "0yf3bwry28zr1yfnx6wyh650d8kac4q70x95kz4p7sr6r7ajwzdm";
    })
  ];

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
