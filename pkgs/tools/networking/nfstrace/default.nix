{ cmake, fetchFromGitHub, fetchpatch, json_c, libpcap, ncurses, stdenv }:

stdenv.mkDerivation rec {
  pname = "nfstrace";
  version = "0.4.3.2";

  src = fetchFromGitHub {
    owner = "epam";
    repo = "nfstrace";
    rev = "${version}";
    sha256 = "1djsyn7i3xp969rnmsdaf5vwjiik9wylxxrc5nm7by00i76c1vsg";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/nfstrace/raw/debian/0.4.3.1-3/debian/patches/reproducible_build.patch";
      sha256 = "0fd96r8xi142kjwibqkd46s6jwsg5kfc5v28bqsj9rdlc2aqmay5";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-Wno-braced-scalar-init" ""
  '';

  buildInputs = [ json_c libpcap ncurses ];
  nativeBuildInputs = [ cmake ];

  # To build with GCC 8+ it needs:
  CXXFLAGS = "-Wno-class-memaccess -Wno-ignored-qualifiers";
  # CMake can't find json_c without:
  NIX_CFLAGS_COMPILE = [ "-I${json_c.dev}/include/json-c" "-Wno-error=address-of-packed-member" ];

  doCheck = false; # requires network access

  meta = with stdenv.lib; {
    homepage = "http://epam.github.io/nfstrace/";
    description = "NFS and CIFS tracing/monitoring/capturing/analyzing tool";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
