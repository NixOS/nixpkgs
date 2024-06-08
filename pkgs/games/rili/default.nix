{ lib, stdenv, fetchurl, fetchpatch, SDL_mixer, SDL, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "ri_li";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/ri-li/Ri-li-${version}.tar.bz2";
    sha256 = "f71ccc20c37c601358d963e087ac0d524de8c68e96df09c3aac1ae65edd38dbd";
  };

  patches = [
    ./moderinze_cpp.patch

    # Build fix for gcc-11 pending upstream inclusion:
    #  https://sourceforge.net/p/ri-li/bugs/2/
    (fetchpatch {
      name = "gcc-11.patch";
      url = "https://sourceforge.net/p/ri-li/bugs/2/attachment/0001-Fix-build-on-gcc-11.patch";
      sha256 = "01il9lm3amwp3b435ka9q63p0jwlzajwnbshyazx6n9vcnrr17yw";
    })
  ];

  CPPFLAGS = "-I${lib.getDev SDL}/include -I${lib.getDev SDL}/include/SDL -I${SDL_mixer}/include";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ SDL SDL_mixer ];

  meta = {
    homepage = "https://ri-li.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    description = "A children's train game";
    longDescription = ''
     Ri-li is an arcade game licensed under the GPL (General Public License).
You drive a toy wood engine in many levels and you must collect all the coaches
to win.
    '';
    maintainers = with lib.maintainers; [ jcumming ];
    platforms = with lib.platforms; linux;
    mainProgram = "Ri_li";
  };
}
