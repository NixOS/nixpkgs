{ stdenv, fetchFromGitHub, pkg-config, SDL2 }:

stdenv.mkDerivation rec {
  pname = "stella";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = pname;
    rev = version;
    sha256 = "sha256-5rH2a/Uvi0HuyU/86y87g5FN/dunlP65+K3j0Bo+yCg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib;{
    description = "An open-source Atari 2600 VCS emulator";
    longDescription = ''
    Stella is a multi-platform Atari 2600 VCS emulator released under
    the GNU General Public License (GPL). Stella was originally
    developed for Linux by Bradford W. Mott, and is currently
    maintained by Stephen Anthony.
    As of its 3.5 release, Stella is officially donationware.
    '';
    homepage = "https://stella-emu.github.io/";
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
