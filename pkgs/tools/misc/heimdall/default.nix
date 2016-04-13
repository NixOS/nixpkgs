{ stdenv, fetchFromGitHub, zlib, libusb1, cmake, qt5
, enableGUI ? false }:

let version = "d0526a3"; in
let verName = "1.4.2pre"; in

stdenv.mkDerivation rec {
  name = "heimdall-${verName}";

  src = fetchFromGitHub {
    owner  = "Benjamin-Dobell";
    repo   = "Heimdall";
    rev    = "${version}";
    sha256 = "1y8gvqprajlml1z6mjcrlj54m9xsr8691nqagakkkis7hs1lgzmp";
  };

  buildInputs = [ zlib libusb1 cmake ];
  patchPhase = stdenv.lib.optional (!enableGUI) ''
    sed -i '/heimdall-frontend/d' CMakeLists.txt
  '';
  enableParallelBuilding = true;
  cmakeFlags = ["-DQt5Widgets_DIR=${qt5.qtbase}/lib/cmake/Qt5Widgets"
                "-DQt5Gui_DIR=${qt5.qtbase}/lib/cmake/Qt5Gui"
                "-DQt5Core_DIR=${qt5.qtbase}/lib/cmake/Qt5Core"
                "-DBUILD_TYPE=Release"];

  preConfigure =
    ''
      # Give ownership of the Galaxy S USB device to the logged in user.
      substituteInPlace heimdall/60-heimdall.rules --replace 'MODE="0666"' 'TAG+="uaccess"'
    '';

  installPhase =
    ''
      mkdir -p $out/bin $out/share/doc/heimdall $out/lib/udev/rules.d
      cp bin/heimdall $out/bin
      cp ../Linux/README $out/share/doc/heimdall
      cp ../heimdall/60-heimdall.rules $out/lib/udev/rules.d
    '' + stdenv.lib.optionalString enableGUI ''
      cp bin/heimdall-frontend $out/bin
    '';

  meta = {
    homepage = http://www.glassechidna.com.au/products/heimdall/;
    description = "A cross-platform open-source tool suite used to flash firmware onto Samsung Galaxy S devices";
    license = stdenv.lib.licenses.mit;
  };
}
