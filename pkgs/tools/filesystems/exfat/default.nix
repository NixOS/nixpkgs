{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fuse }:

let version = "1.2.0"; in
stdenv.mkDerivation rec {
  name = "exfat-${version}";

  src = fetchFromGitHub {
    sha256 = "1fsm082g8phqcdg5md6yll06jijnbvqrdy0638psa8kr159h4dv8";
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

