{ stdenv, fetchurl, pkgconfig, SDL2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "stella-${version}";
  version = "4.6";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/stella/stella/${version}/${name}-src.tar.gz";
    sha256 = "03vg8cxr0hn99vrr2dcwhv610xi9vhlw08ypazpm0nny522a9j4d";
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig SDL2 ];

  meta = {
    description = "An open-source Atari 2600 VCS emulator";
    longDescription = ''
    Stella is a multi-platform Atari 2600 VCS emulator released under
    the GNU General Public License (GPL). Stella was originally
    developed for Linux by Bradford W. Mott, and is currently
    maintained by Stephen Anthony.
    As of its 3.5 release, Stella is officially donationware. 
    '';
    homepage = http://stella.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
