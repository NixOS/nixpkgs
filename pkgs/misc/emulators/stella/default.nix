{ stdenv, fetchFromGitHub, pkgconfig, SDL2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "stella";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = version;
    sha256 = "0m4vdgn7gqhga7hamy4djnlkfgz78gfkmg8by3mai5lw0cps7hr1";
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
    homepage = "http://stella-emu.github.io/";
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
