{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, libpsm2 }:

stdenv.mkDerivation rec {
  pname = "libfabric";
  version = "1.11.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wgn6gsiy64rb76i46dsqlvp687lwqzxwg5lgj1y5y7lyqbq96wp";
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
