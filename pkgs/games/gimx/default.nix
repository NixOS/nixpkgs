{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, libusb1, xorg, libxml2
, ncurses5, bluez, libmhash, gimxPdpGamepad ? false }:

let
  gimx-config = fetchFromGitHub {
    owner = "matlo";
    repo = "GIMX-configurations";
    rev = "c20300f24d32651d369e2b27614b62f4b856e4a0";
    sha256 = "02wcjk8da188x7y0jf3p0arjdh9zbb0lla3fxdb28b1xyybfvx5p";
  };

in stdenv.mkDerivation rec {
  pname = "gimx";
  version = "unstable-2021-08-31";

  src = fetchFromGitHub {
    owner = "matlo";
    repo = "GIMX";
    rev = "58d2098dce75ed4c90ae649460d3a7a150f4ef0a";
    fetchSubmodules = true;
    sha256 = "05kdv2qqr311c2p76hdlgvrq7b04vcpps5c80zn8b8l7p831ilgz";
  };

  patches = [ ./conf.patch ];
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    curl libusb1 bluez libxml2 ncurses5 libmhash
    xorg.libX11 xorg.libXi xorg.libXext
  ];

  postPatch = lib.optionals gimxPdpGamepad ''
    substituteInPlace ./shared/gimxcontroller/include/x360.h \
      --replace "0x045e" "0x0e6f" --replace "0x028e" "0x0213"
    substituteInPlace ./loader/firmware/EMU360.hex \
      --replace "1B210001" "1B211001" \
      --replace "09210001" "09211001" \
      --replace "5E048E021001" "6F0E13020001"
  '';

  makeFlags = [ "build-core" ];

  NIX_CFLAGS_COMPILE = [
    # Needed with GCC 12
    "-Wno-error=address"
    "-Wno-error=deprecated-declarations"
    "-Wno-error=use-after-free"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    substituteInPlace ./core/Makefile --replace "chmod ug+s" "echo"

    export DESTDIR="$out"
    make install-shared install-core
    mv $out/usr/lib $out/lib
    mv $out/usr/bin $out/bin
    rmdir $out/usr

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -r ./loader/firmware $out/share/firmware
    cp -r ${gimx-config}/Linux $out/share/config
    cp -r ${./custom} $out/share/custom

    makeWrapper $out/bin/gimx $out/bin/gimx-dualshock4 \
      --set GIMXCONF 1 --add-flags "--nograb" --add-flags "-p /dev/ttyUSB0" \
      --add-flags "-c $out/share/custom/Dualshock4.xml"

    makeWrapper $out/bin/gimx $out/bin/gimx-xboxonepad \
      --set GIMXCONF 1 --add-flags "--nograb" --add-flags "-p /dev/ttyUSB0" \
      --add-flags "-c $out/share/config/XOnePadUsb.xml"
  '';

  meta = with lib; {
    homepage = "https://github.com/matlo/GIMX";
    description = "Game Input Multiplexer";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bb2020 ];
  };
}
