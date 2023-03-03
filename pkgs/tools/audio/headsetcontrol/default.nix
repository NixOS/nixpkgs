{ stdenv
, lib
, fetchFromGitHub
, cmake
, hidapi
}:

stdenv.mkDerivation rec {
  pname = "headsetcontrol";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Sapd";
    repo = "HeadsetControl";
    rev = version;
    sha256 = "sha256-SVOcRzR52RYZsk/OWAr1/s+Nm6x48OxG0TF7yQ+Kb94=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    hidapi
  ];

  /*
  Test depends on having the apropiate headsets connected.
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
