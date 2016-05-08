{ stdenv, fetchFromGitHub, zlib, libusb1, cmake, qt5, enableGUI ? false }:

let version = "1.4.1-34-g7ebee1e"; in

stdenv.mkDerivation {
  name = "heimdall-${version}";

  src = fetchFromGitHub {
    owner  = "Benjamin-Dobell";
    repo   = "Heimdall";
    rev    = "v${version}";
    sha256 = "10c71k251wxd05j6c76qlar5sd73zam1c1g2cq3cscqayd7rzafg";
  };

  buildInputs = [ zlib libusb1 cmake ];
  patchPhase = stdenv.lib.optional (!enableGUI) ''
    sed -i '/heimdall-frontend/d' CMakeLists.txt
  '';
  enableParallelBuilding = true;
  cmakeFlags = [
    "-DQt5Widgets_DIR=${qt5.qtbase}/lib/cmake/Qt5Widgets"
    "-DQt5Gui_DIR=${qt5.qtbase}/lib/cmake/Qt5Gui"
    "-DQt5Core_DIR=${qt5.qtbase}/lib/cmake/Qt5Core"
    "-DBUILD_TYPE=Release"
  ];

  preConfigure = ''
    # Give ownership of the Galaxy S USB device to the logged in user.
    substituteInPlace heimdall/60-heimdall.rules --replace 'MODE="0666"' 'TAG+="uaccess"'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/heimdall $out/lib/udev/rules.d
    cp "bin/"* $out/bin/
    cp ../Linux/README $out/share/doc/heimdall
    cp ../heimdall/60-heimdall.rules $out/lib/udev/rules.d
  '';

  meta = {
    homepage = "http://www.glassechidna.com.au/products/heimdall/";
    description = "A cross-platform tool suite to flash firmware onto Samsung Galaxy S devices";
    license = stdenv.lib.licenses.mit;
  };
}
