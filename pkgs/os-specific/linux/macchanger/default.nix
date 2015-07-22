{ stdenv, fetchFromGitHub, autoreconfHook, texinfo }:

let
  pname = "macchanger";
  version = "1.7.0";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "alobbs";
    repo = "macchanger";
    rev = version;
    sha256 = "1hypx6sxhd2b1nsxj314hpkhj7q4x9p2kfaaf20rjkkkig0nck9r";
  };

  buildInputs = [ autoreconfHook texinfo ];

  meta = {
    description = "A utility for viewing/manipulating the MAC address of network interfaces";
    maintainers = [ stdenv.lib.maintainers.joachifm ];
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = "https://www.gnu.org/software/macchanger";
    platforms = stdenv.lib.platforms.linux;
  };
}
