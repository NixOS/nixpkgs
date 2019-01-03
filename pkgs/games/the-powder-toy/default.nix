{ stdenv, fetchFromGitHub, scons, pkgconfig, SDL, lua, fftwFloat, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "the-powder-toy-${version}";
  version = "93.3";

  src = fetchFromGitHub {
    owner = "ThePowderToy";
    repo = "The-Powder-Toy";
    rev = "v${version}";
    sha256 = "1bg1y13kpqxx4mpncxvmg8w02dyqyd9hl43rwnys3sqrjdm9k02j";
  };

  nativeBuildInputs = [ scons pkgconfig ];

  buildInputs = [ SDL lua fftwFloat zlib bzip2 ];

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
