{ stdenv, lib, requireFile, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  pname = "decklink";
  version = "12.2a12";

  src = requireFile {
    name = "Blackmagic_Desktop_Video_Linux_${lib.versions.majorMinor version}.tar.gz";
    url = "https://www.blackmagicdesign.com/support/download/33abc1034cd54cf99101f9acd2edd93d/Linux";
    sha256 = "62954a18b60d9040aa4a959dff30ac9c260218ef78d6a63cbb243788f7abc05f";
  };

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
