{ stdenv, fetchurl, pkgconfig, SDL2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "stella-${version}";
  version = "4.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/stella/stella/${version}/${name}-src.tar.gz";
    sha256 = "126jph21b70jlxapzmll8pq36i53lb304hbsiap25160vdqid4n1";
  };

  buildInputs = [ pkgconfig SDL2 ];

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
