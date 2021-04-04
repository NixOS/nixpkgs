{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, libpsm2 }:

stdenv.mkDerivation rec {
  pname = "libfabric";
  version = "1.12.1";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J2PoDwjPWYpagX4M2k9E1xitBzgRUZzwX9Gf00H+Tdc=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ] ;

  buildInputs = [ libpsm2 ] ;

  configureFlags = [ "--enable-psm2=${libpsm2}" ] ;

  meta = with lib; {
    homepage = "http://libfabric.org/";
    description = "Open Fabric Interfaces";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.bzizou ];
  };
}
