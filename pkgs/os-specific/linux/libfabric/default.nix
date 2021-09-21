{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, libpsm2 }:

stdenv.mkDerivation rec {
  pname = "libfabric";
  version = "1.13.1";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0USQMBXZrbz4GtXLNsSti9ohUOqqo0OCtVz+0Uk9ndI=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ] ;

  buildInputs = [ libpsm2 ] ;

  configureFlags = [ "--enable-psm2=${libpsm2}" ] ;

  meta = with lib; {
    homepage = "https://ofiwg.github.io/libfabric/";
    description = "Open Fabric Interfaces";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.bzizou ];
  };
}
