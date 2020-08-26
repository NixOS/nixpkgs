{ stdenv, fetchFromGitHub, cmake, SDL2, SDL2_mixer, libpng }:

stdenv.mkDerivation rec {
  pname = "julius";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "bvschaik";
    repo = "julius";
    rev = "v${version}";
    sha256 = "12hhnhdwgz7hd3hlndbnk15pxggm1375qs0764ija4nl1gbpb110";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 SDL2_mixer libpng ];

  meta = with stdenv.lib; {
    description = "An open source re-implementation of Caesar III";
    homepage = "https://github.com/bvschaik/julius";
    license = licenses.agpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ Thra11 ];
  };
}
