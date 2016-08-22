{ stdenv, fetchFromGitHub, scons, pkgconfig, SDL, lua, fftwFloat }:

stdenv.mkDerivation rec {
  name = "the-powder-toy-${version}";
  version = "91.5.330";

  src = fetchFromGitHub {
    owner = "simtr";
    repo = "The-Powder-Toy";
    rev = "v${version}";
    sha256 = "19m7jyg3pnppymvr6lz454mjiw18hvldpdhi33596m9ji3nrq8x7";
  };

  patches = [ ./fix-env.patch ];

  nativeBuildInputs = [ scons pkgconfig ];

  buildInputs = [ SDL lua fftwFloat ];

  buildPhase = "scons DESTDIR=$out/bin --tool='' -j$NIX_BUILD_CORES";

  installPhase = ''
    install -Dm 755 build/powder* "$out/bin/powder"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A free 2D physics sandbox game";
    homepage = http://powdertoy.co.uk/;
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
