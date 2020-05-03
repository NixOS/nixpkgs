{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  pname = "inadyn";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "00jhayx0hfl9dw78d58bdxa5390bvxq73lz26q9h1gg1xw76adan";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ gnutls libite libconfuse ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://troglobit.com/project/inadyn/";
    description = "Free dynamic DNS client";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
