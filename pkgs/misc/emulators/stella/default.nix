{ stdenv, fetchurl, pkgconfig
, SDL2 }:

stdenv.mkDerivation rec {

  name = "stella-${version}";
  version = "4.0";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/stella/stella/${version}/${name}-src.tar.gz";
    sha256 = "1j96sj2qflq3agb7fvb08ih3pxy8nsvlkwj40q3n00q9k884ad5w";
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig SDL2 ];

  meta = with stdenv.lib; {
    description = "An open-source Atari 2600 VCS emulator";
    longDescription = ''
    Stella is a multi-platform Atari 2600 VCS emulator released under
    the GNU General Public License (GPL). Stella was originally
    developed for Linux by Bradford W. Mott, and is currently
    maintained by Stephen Anthony.
    As of its 3.5 release, Stella is officialy donationware. 
    '';
    homepage = http://stella.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
