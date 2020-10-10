{ stdenv, fetchFromGitHub, pkgconfig, SDL2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "stella";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = version;
    sha256 = "0a687qdd1qxdz2wzx557vgylv4c37cpypz2gr7p432rgymmzdcg6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ SDL2 ];

  enableParallelBuilding = true;

  meta = {
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
