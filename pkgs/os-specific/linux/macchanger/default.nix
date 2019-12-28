{ stdenv, fetchFromGitHub, autoreconfHook, texinfo }:

stdenv.mkDerivation rec {
  pname = "macchanger";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "alobbs";
    repo = "macchanger";
    rev = version;
    sha256 = "1hypx6sxhd2b1nsxj314hpkhj7q4x9p2kfaaf20rjkkkig0nck9r";
  };

  nativeBuildInputs = [ autoreconfHook texinfo ];

  outputs = [ "out" "info" ];

  meta = with stdenv.lib; {
    description = "A utility for viewing/manipulating the MAC address of network interfaces";
    maintainers = with maintainers; [ joachifm ma27 ];
    license = licenses.gpl2Plus;
    homepage = https://www.gnu.org/software/macchanger;
    platforms = platforms.linux;
  };
}
