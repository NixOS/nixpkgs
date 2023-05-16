{ stdenv
, lib
, fetchFromGitHub
, cmake
, hidapi
}:

stdenv.mkDerivation rec {
  pname = "headsetcontrol";
<<<<<<< HEAD
  version = "2.7.0";
=======
  version = "2.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Sapd";
    repo = "HeadsetControl";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-tAndkfLEgj81JWzXtDBNspRxzKAL6XaRw0aDI1XbC1E=";
=======
    sha256 = "sha256-SVOcRzR52RYZsk/OWAr1/s+Nm6x48OxG0TF7yQ+Kb94=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    hidapi
  ];

  /*
<<<<<<< HEAD
  Tests depend on having the appropriate headsets connected.
=======
  Test depends on having the apropiate headsets connected.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  */
  doCheck = false;

  meta = with lib; {
    description = "Sidetone and Battery status for Logitech G930, G533, G633, G933 SteelSeries Arctis 7/PRO 2019 and Corsair VOID (Pro)";
    longDescription = ''
      A tool to control certain aspects of USB-connected headsets on Linux. Currently,
      support is provided for adjusting sidetone, getting battery state, controlling
      LEDs, and setting the inactive time.
    '';
    homepage = "https://github.com/Sapd/HeadsetControl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leixb ];
    platforms = platforms.all;
  };
}
