{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, libpsm2 }:

stdenv.mkDerivation rec {
  pname = "libfabric";
  version = "1.10.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0amgc5w7qg96r9a21jl92m6jzn4z2j3iyk7jf7kwyzfi4jhlkv89";
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
