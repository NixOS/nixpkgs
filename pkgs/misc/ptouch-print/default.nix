{ lib
, stdenv
, fetchgit
, cmake
, gettext
, gd
, libusb1
, pkg-config
}:

stdenv.mkDerivation {
  pname = "ptouch-print";
  version = "1.5";

  src = fetchgit {
    url = "https://git.familie-radermacher.ch/linux/ptouch-print.git";
    rev = "e3c0073466ed99dbde9bbbcceea1c54f64967fc8";
    sha256 = "sha256-Tn7sODj0NqLUAIHYwcR8BK63/EHMwwR5M9EkFHur0gY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gd
    gettext
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
    license = licenses.gpl3Plus;
    homepage = "https://dominic.familie-radermacher.ch/projekte/ptouch-print/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
