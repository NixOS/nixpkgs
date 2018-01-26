{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  name = "inadyn-${version}";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "1nkrvd33mnj98m86g3xs27l88l2678qjzjhwpq1k9n8v9k255pd6";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ gnutls libite libconfuse ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://troglobit.com/project/inadyn/;
    description = "Free dynamic DNS client";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
  };
}
