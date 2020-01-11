{ stdenv, fetchFromGitHub, scons, pkgconfig, SDL2, lua, fftwFloat, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "the-powder-toy";
  version = "94.1";

  src = fetchFromGitHub {
    owner = "ThePowderToy";
    repo = "The-Powder-Toy";
    rev = "v${version}";
    sha256 = "0w3i4zjkw52qbv3s9cgcwxrdbb1npy0ka7wygyb76xcb17bj0l0b";
  };

  nativeBuildInputs = [ scons pkgconfig ];

  buildInputs = [ SDL2 lua fftwFloat zlib bzip2 ];

  sconsFlags = "--tool=";

  installPhase = ''
    install -Dm 755 build/powder* "$out/bin/powder"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A free 2D physics sandbox game";
    homepage = http://powdertoy.co.uk/;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
