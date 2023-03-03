{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, fuse }:

stdenv.mkDerivation rec {
  pname = "exfat";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "relan";
    repo = "exfat";
    rev = "v${version}";
    sha256 = "1q29pcysv747y6dis07953dkax8k9x50b5gg99gpz6rr46xwgkgb";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse ];

  meta = with lib; {
    description = "Free exFAT file system implementation";
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.unix;
  };
}
