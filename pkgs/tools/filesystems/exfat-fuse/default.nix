{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fuse }:

let version = "1.2.0"; in
stdenv.mkDerivation {
  name = "exfat-fuse-${version}";

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
    homepage = https://github.com/relan/exfat;
    description = "A FUSE file system to read and write to exFAT devices";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
  };
}

