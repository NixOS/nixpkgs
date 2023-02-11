{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  pname = "inadyn";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "sha256-PgG9ElIbJCr607ZrQcmuUcOwr8FSQW+cDytvaNLALnQ=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ gnutls libite libconfuse ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://troglobit.com/projects/inadyn/";
    description = "Free dynamic DNS client";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
