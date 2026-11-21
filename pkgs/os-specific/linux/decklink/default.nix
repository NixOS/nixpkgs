{
  stdenv,
  lib,
  blackmagic-desktop-video,
  kernel,
  kernelModuleMakeFlags,
}:
let
  kernelDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "decklink";

  # the download is a horrible curl mess. we reuse it between the kernel module
  # and desktop service, since the version of the two have to match anyways.
  # See pkgs/by-name/bl/blackmagic-desktop-video/package.nix for more.
  inherit (blackmagic-desktop-video) src version;

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  postUnpack =
    let
      arch = stdenv.hostPlatform.uname.processor;
    in
    ''
      tar xf Blackmagic_Desktop_Video_Linux_${finalAttrs.version}/other/${arch}/desktopvideo-${finalAttrs.version}*-${arch}.tar.gz
      bmVersion=$(ls -d $NIX_BUILD_TOP/desktopvideo-${finalAttrs.version}*-${arch}/usr/src | sed -e 's/.*desktopvideo-\([[:digit:]\.a-z]\+\).*/\1/')

      sourceRoot=$NIX_BUILD_TOP/desktopvideo-$bmVersion-${arch}/usr/src
    '';

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  buildPhase = ''
    runHook preBuild

    mv $sourceRoot/blackmagic-$bmVersion/bmd-support.o_shipped $sourceRoot/blackmagic-$bmVersion/bmd-support.o
    mv $sourceRoot/blackmagic-io-$bmVersion/blackmagic.o_shipped $sourceRoot/blackmagic-io-$bmVersion/blackmagic.o

    touch $sourceRoot/blackmagic-$bmVersion/.bmd-support.o.cmd
    touch $sourceRoot/blackmagic-io-$bmVersion/.blackmagic.o.cmd

    make -C ${kernelDir} M=$sourceRoot/blackmagic-$bmVersion "''${makeFlags[@]}" modules
    make -C ${kernelDir} M=$sourceRoot/blackmagic-io-$bmVersion "''${makeFlags[@]}" modules

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C ${kernelDir} M=$sourceRoot/blackmagic-$bmVersion "''${makeFlags[@]}" modules_install
    make -C ${kernelDir} M=$sourceRoot/blackmagic-io-$bmVersion "''${makeFlags[@]}" modules_install
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    maintainers = [ lib.maintainers.naxdy ];
    license = lib.licenses.unfree;
    description = "Kernel module for the Blackmagic Design Decklink cards";
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
    platforms = lib.platforms.linux;
  };
})
