{ stdenv, fetchFromGitHub, pkgconfig, SDL2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "stella";
  version = "6.2";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = version;
    sha256 = "1d97g4m686xsj6r5vy5x74ys9yk0hcpdppxh714n8hhcc9aglm19";
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
