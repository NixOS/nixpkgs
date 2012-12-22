{stdenv, fetchurl, SDL_mixer, SDL, autoconf, automake}:

stdenv.mkDerivation {
  name = "ri_li-2.0.1"; 
  
  src = fetchurl {
    url = mirror://sourceforge/ri-li/Ri-li-2.0.1.tar.bz2;
    sha256 = "f71ccc20c37c601358d963e087ac0d524de8c68e96df09c3aac1ae65edd38dbd";
  };

  patches = [ ./moderinze_cpp.patch ];

  preConfigure = ''
    export CPPFLAGS="-I${SDL}/include -I${SDL}/include/SDL -I${SDL_mixer}/include"
    autoreconf -i
  '';
  
  buildInputs = [SDL SDL_mixer autoconf automake];
  
  meta = {
    homepage = http://ri-li.sourceforge.net;
    license = "GPL2+";
    description = "A children's train game";
    longDescription = ''
     Ri-li is an arcade game licensed under the GPL (General Public License).
You drive a toy wood engine in many levels and you must collect all the coaches
to win.
    '';
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
