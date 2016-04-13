{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fuse }:

stdenv.mkDerivation rec {
  name = "exfat-${version}";
  version = "1.2.3";

  src = fetchFromGitHub {
    sha256 = "147s11sqmn5flbvz2hwpl6kdfqi2gnm1c2nsn5fxygyw7qyhpzda";
    rev = "v${version}";
    repo = "exfat";
    owner = "relan";
  };

  buildInputs = [ fuse ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Free exFAT file system implementation";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
  };
}
