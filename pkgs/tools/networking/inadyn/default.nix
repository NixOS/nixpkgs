{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  pname = "inadyn";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "sha256-WYl602gDcPKxjQAlBedPHEOCNtaGgcaVZ/KbxcP2El4=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ gnutls libite libconfuse ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://troglobit.com/project/inadyn/";
    description = "Free dynamic DNS client";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
