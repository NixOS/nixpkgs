{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fuse }:

let version = "1.2.1"; in
stdenv.mkDerivation rec {
  name = "exfat-${version}";

  src = fetchFromGitHub {
    sha256 = "1k716civkxszkzpc7bcqqcmfik8lpwk3zwp2nl4v844b8g7r5xz9";
    rev = "v${version}";
    repo = "exfat";
    owner = "relan";
  };

  buildInputs = [ fuse ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  meta = with stdenv.lib; {
    inherit version;
    inherit (src.meta) homepage;
    description = "Free exFAT file system implementation";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
  };
}
