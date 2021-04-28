{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, libusb1, xorg, libxml2
, ncurses5, bluez, libmhash, gimxAuth ? "" }:

let
  gimx-config = fetchFromGitHub {
    owner = "matlo";
    repo = "GIMX-configurations";
    rev = "c20300f24d32651d369e2b27614b62f4b856e4a0";
    sha256 = "02wcjk8da188x7y0jf3p0arjdh9zbb0lla3fxdb28b1xyybfvx5p";
  };

in stdenv.mkDerivation rec {
  pname = "gimx";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "matlo";
    repo = "GIMX";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0265gg6q7ymg76fb4pjrfdwjd280b3zzry96qy92w0h411slph85";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    curl libusb1 bluez libxml2 ncurses5 libmhash
    xorg.libX11 xorg.libXi xorg.libXext
  ];

  patches = [ ./env.patch ];
  prePatch = (if gimxAuth == "afterglow" then (import ./variant.nix).afterglow
              else "");

  makeFlags = "build-core";
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

    makeWrapper $out/bin/gimx $out/bin/gimx-with-confs \
      --set GIMXCONF $out/share/config

    makeWrapper $out/bin/gimx $out/bin/gimx-test-ds4 \
      --set GIMXCONF $out/share/config \
      --add-flags "--nograb" --add-flags "--curses" \
      --add-flags "-p /dev/ttyUSB0" --add-flags "-c Dualshock4.xml"

    makeWrapper $out/bin/gimx $out/bin/gimx-test-xone \
      --set GIMXCONF $out/share/config \
      --add-flags "--nograb" --add-flags "--curses" \
      --add-flags "-p /dev/ttyUSB0" --add-flags "-c XOnePadUsb.xml"
  '';

  meta = with lib; {
    homepage = "https://github.com/matlo/GIMX";
    description = "Game Input Multiplexer";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bb2020 ];
  };
}
