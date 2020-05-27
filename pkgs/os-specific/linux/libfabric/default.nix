{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, libpsm2 }:

stdenv.mkDerivation rec {
  pname = "libfabric";
  version = "1.10.1";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nf5x4v9rhyd67r6f6q3dw4sraaja8jfdkhhg9g8x41czmx4d456";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ] ;

  buildInputs = [ libpsm2 ] ;

  configureFlags = [ "--enable-psm2=${libpsm2}" ] ;

  meta = with stdenv.lib; {
    homepage = "http://libfabric.org/";
    description = "Open Fabric Interfaces";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.bzizou ];
  };
}
