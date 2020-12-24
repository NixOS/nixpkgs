{ stdenv, fetchFromGitHub, poco, openssl, SDL2, SDL2_mixer }:

let
  craftos2-lua = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2-lua";
    rev = "v2.4.4";
    sha256 = "1q63ki4sxx8bxaa6ag3xj153p7a8a12ivm0k33k935p41k6y2k64";
  };
in

stdenv.mkDerivation rec {
  pname = "craftos-pc";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2";
    rev = "v${version}";
    sha256 = "00a4p365krbdprlv4979d13mm3alhxgzzj3vqz2g67795plf64j4";
  };

  buildInputs = [ poco openssl SDL2 SDL2_mixer ];

  preBuild = ''
    cp -R ${craftos2-lua}/* ./craftos2-lua/
    chmod -R u+w ./craftos2-lua
    make -C craftos2-lua linux
  '';

  installPhase = ''
    mkdir -p $out/bin
    DESTDIR=$out/bin make install
  '';

  meta = with stdenv.lib; {
    description = "An implementation of the CraftOS-PC API written in C++ using SDL";
    homepage = "https://www.craftos-pc.cc";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.siraben ];
  };
}
