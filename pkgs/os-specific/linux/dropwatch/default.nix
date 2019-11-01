{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libnl, readline, libbfd, ncurses, zlib }:

stdenv.mkDerivation rec {
  pname = "dropwatch";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qmax0l7z1qik42c949fnvjh5r6awk4gpgzdsny8iwnmwzjyp8b8";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libbfd libnl ncurses readline zlib ];

  # To avoid running into https://sourceware.org/bugzilla/show_bug.cgi?id=14243 we need to define:
  NIX_CFLAGS_COMPILE = "-DPACKAGE=${pname} -DPACKAGE_VERSION=${version}";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Linux kernel dropped packet monitor";
    homepage = "https://github.com/nhorman/dropwatch";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.c0bw3b ];
  };
}
