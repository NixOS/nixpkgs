{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fuse }:

let version = "1.2.2"; in
stdenv.mkDerivation rec {
  name = "exfat-${version}";

  src = fetchFromGitHub {
    sha256 = "17yyd988l4r5w3q3h3hjlxprbw74wdg4n759lzg325smh96qk7p1";
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
