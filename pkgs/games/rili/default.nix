{ lib, stdenv, fetchurl, SDL_mixer, SDL, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "ri_li";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/ri-li/Ri-li-${version}.tar.bz2";
    sha256 = "f71ccc20c37c601358d963e087ac0d524de8c68e96df09c3aac1ae65edd38dbd";
  };

  patches = [ ./moderinze_cpp.patch ];

  CPPFLAGS = "-I${SDL.dev}/include -I${SDL.dev}/include/SDL -I${SDL_mixer}/include";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ SDL SDL_mixer ];

  meta = {
    homepage = "http://ri-li.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    description = "A children's train game";
    longDescription = ''
     Ri-li is an arcade game licensed under the GPL (General Public License).
You drive a toy wood engine in many levels and you must collect all the coaches
to win.
    '';
    maintainers = with lib.maintainers; [ jcumming ];
    platforms = with lib.platforms; linux;
  };
}
