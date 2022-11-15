{ lib
, stdenv
, cups
, fetchzip
, patchPpdFilesHook
}:

let
  platform =
    if stdenv.hostPlatform.system == "x86_64-linux" then "64bit"
    else if stdenv.hostPlatform.system == "i686-linux" then "32bit"
         else throw "Unsupported system: ${stdenv.hostPlatform.system}";

  libPath = lib.makeLibraryPath [ cups ];
in

stdenv.mkDerivation {
  pname = "cups-kyocera";
  version = "1.1203";

  dontPatchELF = true;
  dontStrip = true;

  src = fetchzip {
    # this site does not like curl -> override useragent
    curlOpts = "-A ''";
    url = "https://cdn.kyostatics.net/dlc/ru/driver/all/linuxdrv_1_1203_fs-1x2xmfp.-downloadcenteritem-Single-File.downloadcenteritem.tmp/LinuxDrv_1.1203_FS-1x2xMFP.zip";
    sha256 = "0z1pbgidkibv4j21z0ys8cq1lafc6687syqa07qij2qd8zp15wiz";
  };

  nativeBuildInputs = [ patchPpdFilesHook ];

  installPhase = ''
    runHook preInstall

    tar -xvf ${platform}/Global/English.tar.gz
    install -Dm755 English/rastertokpsl $out/lib/cups/filter/rastertokpsl
    patchelf \
      --set-rpath ${libPath} \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/lib/cups/filter/rastertokpsl

    mkdir -p $out/share/cups/model/Kyocera
    cd English
    cp *.ppd $out/share/cups/model/Kyocera

    runHook postInstall
  '';

  ppdFileCommands = [ "rastertokpsl" ];

  meta = with lib; {
    description = "CUPS drivers for several Kyocera FS-{1020,1025,1040,1060,1120,1125} printers";
    homepage = "https://www.kyoceradocumentsolutions.ru/index/service_support/download_center.false.driver.FS1040._.EN.html#";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ maintainers.vanzef ];
    platforms = platforms.linux;
  };
}
