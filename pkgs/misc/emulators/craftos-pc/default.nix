{ lib, stdenv, fetchFromGitHub, poco, openssl, SDL2, SDL2_mixer, ncurses, libpng
, libharu, ApplicationServices, pngpp, libX11, Cocoa, xlibsWrapper }:

stdenv.mkDerivation rec {
  pname = "craftos-pc";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2";
    rev = "v${version}";
    sha256 = "sha256-ml3RkZb4YGNGyJJkHW3wLRp1Rzpeb0tEJ0jS1Rmmzns=";
    fetchSubmodules = true;
  };

  buildInputs = [ poco openssl SDL2 SDL2_mixer ncurses libpng libharu pngpp libX11 xlibsWrapper ]
     ++ lib.optionals stdenv.isDarwin [ ApplicationServices Cocoa ];

  preBuild = ''
    make -C craftos2-lua ${if stdenv.isLinux then "linux" else "macosx"}
  '';

  installPhase = ''
    mkdir -p $out/bin
    DESTDIR=$out/bin make install
  '';

  meta = with lib; {
    description = "An implementation of the CraftOS-PC API written in C++ using SDL";
    homepage = "https://www.craftos-pc.cc";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.siraben ];
  };
}
