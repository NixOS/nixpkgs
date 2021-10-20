{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {

  pname = "idsk";
  version = "0.20";

  src = fetchFromGitHub {
    repo = "idsk";
    owner = "cpcsdk";
    rev = "v${version}";
    sha256 = "05zbdkb9s6sfkni6k927795w2fqdhnf3i7kgl27715sdmmdab05d";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    cp iDSK $out/bin
  '';

  meta = with lib; {
    description = "Manipulating CPC dsk images and files";
    homepage = "https://github.com/cpcsdk/idsk" ;
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
