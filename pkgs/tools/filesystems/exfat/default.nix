{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fuse }:

stdenv.mkDerivation rec {
  name = "exfat-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "relan";
    repo = "exfat";
    rev = "v${version}";
    sha256 = "1q29pcysv747y6dis07953dkax8k9x50b5gg99gpz6rr46xwgkgb";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ fuse ];

  meta = with stdenv.lib; {
    description = "Free exFAT file system implementation";
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
