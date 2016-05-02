{ stdenv, fetchFromGitHub, scons, pkgconfig, SDL, lua, fftwFloat }:

let version = "91.3.328";
in
stdenv.mkDerivation rec {
  name = "the-powder-toy-${version}";
  src = fetchFromGitHub {
    owner = "simtr";
    repo = "The-Powder-Toy";
    rev = "v${version}";
    sha256 = "0krg4d2m8cnfabm5qq7wr1y53h21i49xjcggzg98xjd0972zvfrk";
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
