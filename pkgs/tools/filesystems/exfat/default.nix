{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fuse }:

stdenv.mkDerivation rec {
  name = "exfat-${version}";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "relan";
    repo = "exfat";
    rev = "v${version}";
    sha256 = "0q02g3yvfmxj70h85a69d8s4f6y7jask268vr87j44ya51lzndd9";
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
