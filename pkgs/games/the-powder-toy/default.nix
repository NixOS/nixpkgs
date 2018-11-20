{ stdenv, fetchFromGitHub, scons, pkgconfig, SDL, lua, fftwFloat, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "the-powder-toy-${version}";
  version = "92.5";

  src = fetchFromGitHub {
    owner = "simtr";
    repo = "The-Powder-Toy";
    rev = "v${version}";
    sha256 = "1n15kgl4qnz55b32ddgmhrv64cl3awbds8arycn7mkf7akwdg1g6";
  };

  patches = [ ./fix-env.patch ];

  postPatch = ''
    sed -i 's,lua5.1,lua,g' SConscript
  '';

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
