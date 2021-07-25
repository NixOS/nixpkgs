{ lib, stdenv, fetchFromGitHub, poco, openssl, SDL2, SDL2_mixer, ncurses, libpng
, libharu, ApplicationServices, pngpp, libX11, Cocoa, xlibsWrapper }:

let
  craftos2-lua = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2-lua";
    rev = "v2.6";
    sha256 = "sha256-82PAxwt50zGLul/HJ9Z1KUFd83F7hPVO8J70tdzYHy4=";
  };
in

stdenv.mkDerivation rec {
  pname = "craftos-pc";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2";
    rev = "v${version}";
    sha256 = "sha256-x3SBZwpgcTUOCJBck+dkPmN94T3xoRPIo3c5EYIZ8iQ=";
  };

  buildInputs = [ poco openssl SDL2 SDL2_mixer ncurses libpng libharu pngpp libX11 xlibsWrapper ]
     ++ lib.optionals stdenv.isDarwin [ ApplicationServices Cocoa ];

  preBuild = ''
    cp -R ${craftos2-lua}/* ./craftos2-lua/
    chmod -R u+w ./craftos2-lua
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
