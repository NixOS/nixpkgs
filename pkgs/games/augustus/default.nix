{ stdenv, fetchFromGitHub, cmake, SDL2, SDL2_mixer, libpng }:

stdenv.mkDerivation rec {
  pname = "augustus";
  version = "1.4.1a";

  src = fetchFromGitHub {
    owner = "Keriew";
    repo = "augustus";
    rev = "v${version}";
    sha256 = "1xqv8j8jh3f13fjhyf7hk1anrn799cwwsvsd75kpl9n5yh5s1j5y";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 SDL2_mixer libpng ];

  meta = with stdenv.lib; {
    description = "An open source re-implementation of Caesar III. Fork of Julius incorporating gameplay changes";
    homepage = "https://github.com/Keriew/augustus";
    license = licenses.agpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ Thra11 ];
  };
}
