{ lib, stdenv, fetchurl, ibus, ibus-table, pkg-config, python3 }:

stdenv.mkDerivation rec {
  pname = "ibus-table-others";
<<<<<<< HEAD
  version = "1.3.17";

  src = fetchurl {
    url = "https://github.com/moebiuscurve/ibus-table-others/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-7//axHjQ1LgLpeWR4MTI8efLURm4Umj4JV3G33Y0m0g=";
  };

  nativeBuildInputs = [ pkg-config python3 ];
  buildInputs = [ ibus ibus-table ];
=======
  version = "1.3.15";

  src = fetchurl {
    url = "https://github.com/moebiuscurve/ibus-table-others/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-nOj5gwhFodZv29hAN6S8EhQ+XlWp31FDOGIXtyAOM1E=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ibus ibus-table python3 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preBuild = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    isIbusEngine = true;
    description  = "Various table-based input methods for IBus";
    homepage     = "https://github.com/moebiuscurve/ibus-table-others";
    license      = licenses.gpl3;
    platforms    = platforms.linux;
<<<<<<< HEAD
    maintainers  = with maintainers; [ mudri McSinyx ];
=======
    maintainers  = with maintainers; [ mudri ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
