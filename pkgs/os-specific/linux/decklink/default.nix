{ stdenv
, lib
, fetchpatch
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

  patches = lib.optionals (lib.versionAtLeast kernel.version "6.8") [
    (fetchpatch {
      name = "decklink-addMutex.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/01-addMutex.patch?h=decklink&id=132ce45a76e230cbfec4a3daac237ffe9b8a377a";
      sha256 = "sha256-YLIjO3wMrMoEZwMX5Fs9W4uRu9Xo8klzsjfhxS2wRfQ=";
    })
    (fetchpatch {
      name = "decklink-changeMaxOrder.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/02-changeMaxOrder.patch?h=decklink&id=132ce45a76e230cbfec4a3daac237ffe9b8a377a";
      sha256 = "sha256-/erUVYjpTuyaQaCSzSxwKgNocxijc1uNaUjnrJEMa6g=";
    })
  ];


  postUnpack = let
    arch = stdenv.hostPlatform.uname.processor;
  in ''
    tar xf Blackmagic_Desktop_Video_Linux_${lib.head (lib.splitString "a" version)}/other/${arch}/desktopvideo-${version}-${arch}.tar.gz
    moduleRoot=$NIX_BUILD_TOP/desktopvideo-${version}-${stdenv.hostPlatform.uname.processor}/usr/src
    sourceRoot=$moduleRoot
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
