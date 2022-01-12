{ lib, stdenv, fetchFromGitHub, poco, openssl, SDL2, SDL2_mixer, ncurses, libpng
, libharu, ApplicationServices, pngpp, libX11, Cocoa, xlibsWrapper, Carbon }:

# let

#   craftos2-lua = fetchFromGitHub {
#     owner = "MCJack123";
#     repo = "craftos2-lua";
#     rev = "v${version}";
#     sha256 = "sha256-82PAxwt00zGLul/HJ9Z1KUFd83F7hPVO8J70tdzYHy4=";
#   };
# in

stdenv.mkDerivation rec {
  pname = "craftos-pc";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2";
    rev = "v${version}";
    sha256 = "sha256-VICaTvDcZ29OwfHq+ubt4yASo3aj6QSE4XSzJAQlDuc=";
    fetchSubmodules = true;
  };

  
  buildInputs = [ poco openssl SDL2 SDL2_mixer ncurses libpng libharu pngpp libX11 xlibsWrapper ]
     ++ lib.optionals stdenv.isDarwin [ ApplicationServices Cocoa Carbon ];

  preBuild = ''
    make -j $NIX_BUILD_CORES -C craftos2-lua ${if stdenv.isLinux then "linux" else "macosx${lib.optionalString stdenv.isAarch64 "-arm"}"}
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
