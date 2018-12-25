{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libnl, readline, libbfd, ncurses, zlib }:

stdenv.mkDerivation rec {
  pname = "dropwatch";
  version = "1.5";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = pname;
    rev = version;
    sha256 = "085hyyl28v0vpxfnmzchl97fjfnzj46ynhkg6y4i6h194y0d99m7";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libbfd libnl ncurses readline zlib ];

  # To avoid running into https://sourceware.org/bugzilla/show_bug.cgi?id=14243 we need to define:
  NIX_CFLAGS_COMPILE = [
    "-DPACKAGE=${pname}"
    "-DPACKAGE_VERSION=${version}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Kernel dropped packet monitor";
    homepage = https://github.com/nhorman/dropwatch;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.c0bw3b ];
  };
}
