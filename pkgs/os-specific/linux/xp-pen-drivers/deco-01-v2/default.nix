{ lib
, stdenv
, fetchzip
, libusb1
, glibc
, libGL
, xorg
, makeWrapper
, qtx11extras
, wrapQtAppsHook
, autoPatchelfHook
, libX11
, libXtst
, libXi
, libXrandr
, libXinerama
}:

let
  dataDir = "var/lib/xppend1v2";
in
stdenv.mkDerivation rec {
  pname = "xp-pen-deco-01-v2-driver";
  version = "3.2.3.230215-1";

  src = fetchzip {
    url = "https://download01.xp-pen.com/file/2023/03/XPPen-pentablet-${version}.x86_64.tar.gz";
    name = "xp-pen-deco-01-v2-driver-${version}.tar.gz";
    sha256 = "sha256-CV4ZaGCFFcfy2J0O8leYgcyzFVwJQFQJsShOv9B7jfI=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    autoPatchelfHook
    makeWrapper
  ];

  dontBuild = true;

  dontWrapQtApps = true; # this is done manually

  buildInputs = [
    libusb1
    libX11
    libXtst
    libXi
    libXrandr
    libXinerama
    glibc
    libGL
    stdenv.cc.cc.lib
    qtx11extras
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt,bin}
    cp -r App/usr/lib/pentablet/{pentablet,resource.rcc,conf} $out/opt
    chmod +x $out/opt/pentablet
    cp -r App/lib $out/lib
    sed -i 's#usr/lib/pentablet#${dataDir}#g' $out/opt/pentablet

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/pentablet $out/bin/xp-pen-deco-01-v2-driver \
      "''${qtWrapperArgs[@]}" \
      --run 'if [ "$EUID" -ne 0 ]; then echo "Please run as root."; exit 1; fi' \
      --run 'if [ ! -d /${dataDir} ]; then mkdir -p /${dataDir}; cp -r '$out'/opt/conf /${dataDir}; chmod u+w -R /${dataDir}; fi'
  '';

  meta = with lib; {
    homepage = "https://www.xp-pen.com/product/461.html";
    description = "Drivers for the XP-PEN Deco 01 v2 drawing tablet";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ virchau13 ];
    license = licenses.unfree;
  };
}

