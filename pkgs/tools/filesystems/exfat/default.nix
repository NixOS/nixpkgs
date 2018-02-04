{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fuse }:

stdenv.mkDerivation rec {
  name = "exfat-${version}";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "relan";
    repo = "exfat";
    rev = "v${version}";
    sha256 = "1sk4z133djh8sdvx2vvmd8kf4qfly2i3hdar4zpg0s41jpbzdx69";
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
