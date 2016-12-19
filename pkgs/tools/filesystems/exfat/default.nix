{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fuse }:

stdenv.mkDerivation rec {
  name = "exfat-${version}";
  version = "1.2.4";

  src = fetchFromGitHub {
    sha256 = "0x8wjvvlqmp0g2361m6d24csi1p4df8za2cqhyys03s1hv1qmy0k";
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
