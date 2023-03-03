{ lib, stdenv, mkDerivation, fetchzip, autoPatchelfHook, libusb1, libX11, libXtst, qtbase, libglvnd }:

mkDerivation rec {
  pname = "xp-pen-g430-driver";
  version = "1.2.13.1";

  src = fetchzip {
    url = "https://download01.xp-pen.com/file/2020/04/Linux_Pentablet_V${version}.tar.gz(20200428).zip";
    sha256 = "1r423hcpi26v82pzl59br1zw5vablikclqsy6mcqi0v5p84hfrdd";
  } + /Linux_Pentablet_V1.2.13.1.tar.gz;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libusb1
    libX11
    libXtst
    qtbase
    libglvnd
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp Pentablet_Driver $out/bin/pentablet-driver
    cp config.xml $out/bin/config.xml
  '';

  meta = with lib; {
    homepage = "https://www.xp-pen.com/download-46.html";
    description = "Driver for XP-PEN Pentablet drawing tablets";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ivar ];
  };
}
