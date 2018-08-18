{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  name = "inadyn-${version}";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "0m2lkmvklhnggv1kim0rikq1gxxc984lsg4gpn8s6lzv6y0axbya";
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
