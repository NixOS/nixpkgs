{ lib
, stdenv
, fetchurl
, autoreconfHook
, pkg-config
, glib
, jansson
, udev
, libgudev
, libusb1
, libdrm
, xorg
}:

stdenv.mkDerivation rec {
  pname = "ddcutil";
  version = "2.1.2";

  src = fetchurl {
    url = "https://www.ddcutil.com/tarballs/ddcutil-${version}.tar.gz";
    hash = "sha256-2SYH+8sEeCY55T8aNO3UJ8NN4g2dfzsv3DlTS2p22/s=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    glib
    jansson
    libdrm
    libgudev
    libusb1
    udev
    xorg.libXext
    xorg.libXrandr
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.ddcutil.com/";
    description = "Query and change Linux monitor settings using DDC/CI and USB";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rnhmjoj ];
    changelog = "https://github.com/rockowitz/ddcutil/blob/v${version}/CHANGELOG.md";
    mainProgram = "ddcutil";
  };
}

