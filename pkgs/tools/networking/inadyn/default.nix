{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  name = "inadyn-${version}";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "1h24yavp1246zn5isypvxrilp6xj2266qr52w2r24qxicr8b320y";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ gnutls libite libconfuse ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://troglobit.com/project/inadyn/;
    description = "Free dynamic DNS client";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
