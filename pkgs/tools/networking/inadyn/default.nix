{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  pname = "inadyn";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "0izhynqfj4xafsrc653wym8arwps0qim203w8l0g5z9vzfxfnvqw";
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
