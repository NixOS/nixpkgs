{ cmake
, fetchgit
, gd
, gettext
, git
, lib
, libjpeg
, libpng
, libusb1
, pkg-config
, stdenv
, zlib
}:

stdenv.mkDerivation rec {
  pname = "ptouch-print";
  version = "1.5-unstable-2024-02-11";

  src = fetchgit {
    url = "https://git.familie-radermacher.ch/linux/ptouch-print.git";
    rev = "8aaeecd84b619587dc3885dd4fea4b7310c82fd4";
    hash = "sha256-IIq3SmMfsgwSYbgG1w/wrBnFtb6xdFK2lkK27Qqk6mw=";
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs = [
    gd
    gettext
    libjpeg
    libpng
    zlib
    libusb1
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv ptouch-print $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line tool to print labels on Brother P-Touch printers on Linux";
    homepage = "https://dominic.familie-radermacher.ch/projekte/ptouch-print/";
    license = licenses.gpl3Plus;
    mainProgram = "ptouch-print";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
