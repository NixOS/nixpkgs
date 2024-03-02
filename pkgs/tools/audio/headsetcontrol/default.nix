{ stdenv
, lib
, fetchFromGitHub
, cmake
, hidapi
}:

stdenv.mkDerivation rec {
  pname = "headsetcontrol";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Sapd";
    repo = "HeadsetControl";
    rev = version;
    sha256 = "sha256-tAndkfLEgj81JWzXtDBNspRxzKAL6XaRw0aDI1XbC1E=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    hidapi
  ];

  /*
  Tests depend on having the appropriate headsets connected.
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
    mainProgram = "headsetcontrol";
    maintainers = with maintainers; [ leixb ];
    platforms = platforms.all;
  };
}
