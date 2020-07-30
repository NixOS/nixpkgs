{ stdenv, fetchFromGitHub, scons, pkgconfig, SDL2, lua, fftwFloat,
  zlib, bzip2, curl, darwin }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "the-powder-toy";
  version = "95.0";

  src = fetchFromGitHub {
    owner = "The-Powder-Toy";
    repo = "The-Powder-Toy";
    rev = "v${version}";
    sha256 = "18rp2g1mj0gklra06wm9dm57h73hmm301npndh0y8ap192i5s8sa";
  };

  nativeBuildInputs = [ scons pkgconfig ];
  
  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin 
    [ (darwin.apple_sdk.frameworks.Cocoa) ];
  
  buildInputs = [ SDL2 lua fftwFloat zlib bzip2 curl ];

  installPhase = ''
    install -Dm 755 build/powder* "$out/bin/powder"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A free 2D physics sandbox game";
    homepage = "http://powdertoy.co.uk/";
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar siraben ];
  };
}
