{ stdenv, fetchFromGitHub, cmake, pkgconfig, SDL2, SDL2_mixer, alsaLib, libpng, pcre }:

stdenv.mkDerivation rec {

  name = "ivan-${version}";
  version = "053";

  src = fetchFromGitHub {
    owner = "Attnam";
    repo = "ivan";
    rev = "v${version}";
    sha256 = "1r3fcccgpjmzzkg0lfmq76igjapr01kh97vz671z60jg7gyh301b";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ SDL2 SDL2_mixer alsaLib libpng pcre ];

  hardeningDisable = ["all"];

  # To store bone and high score files in ~/.ivan of the current user
  patches = [./homedir.patch];

  # Enable wizard mode
  cmakeFlags = ["-DCMAKE_CXX_FLAGS=-DWIZARD"];

  # Help CMake find SDL_mixer.h
  NIX_CFLAGS_COMPILE = "-I${SDL2_mixer}/include/SDL2";

  meta = with stdenv.lib; {
    description = "Graphical roguelike game";
    longDescription = ''
      Iter Vehemens ad Necem (IVAN) is a graphical roguelike game, which currently
      runs in Windows, DOS, Linux, and OS X. It features advanced bodypart and
      material handling, multi-colored lighting and, above all, deep gameplay.

      This is a fan continuation of IVAN by members of Attnam.com
    '';
    homepage = https://attnam.com/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [freepotion];
  };
}
