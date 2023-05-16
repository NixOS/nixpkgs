{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sg3_utils";
<<<<<<< HEAD
  version = "1.48";

  src = fetchurl {
    url = "https://sg.danny.cz/sg/p/sg3_utils-${version}.tgz";
    sha256 = "sha256-1itsPPIDkPpzVwRDkAhBZtJfHZMqETXEULaf5cKD13M=";
=======
  version = "1.47";

  src = fetchurl {
    url = "https://sg.danny.cz/sg/p/sg3_utils-${version}.tgz";
    sha256 = "sha256-hnPH+sqEm2s0dkMy0qqR9y2wW/9zgruDbQaIeVGZw+E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    homepage = "https://sg.danny.cz/sg/";
    description = "Utilities that send SCSI commands to devices";
    platforms = platforms.linux;
    license = with licenses; [ bsd2 gpl2Plus ];
  };
}
