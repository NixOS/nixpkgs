{ cmake, fetchFromGitHub, fetchpatch, json_c, libpcap, ncurses, lib, stdenv, libtirpc }:

stdenv.mkDerivation rec {
  pname = "nfstrace";
  version = "0.4.3.2";

  src = fetchFromGitHub {
    owner = "epam";
    repo = "nfstrace";
    rev = version;
    sha256 = "1djsyn7i3xp969rnmsdaf5vwjiik9wylxxrc5nm7by00i76c1vsg";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/nfstrace/raw/debian/0.4.3.1-3/debian/patches/reproducible_build.patch";
      sha256 = "0fd96r8xi142kjwibqkd46s6jwsg5kfc5v28bqsj9rdlc2aqmay5";
    })
    # Fixes build failure with gcc-10
    # Related PR https://github.com/epam/nfstrace/pull/42/commits/4562a895ed3ac0e811bdd489068ad3ebe4d7b501
    (fetchpatch {
      url = "https://github.com/epam/nfstrace/commit/4562a895ed3ac0e811bdd489068ad3ebe4d7b501.patch";
      sha256 = "1fbicbllyykjknik7asa81x0ixxmbwqwkiz74cnznagv10jlkj3p";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-Wno-braced-scalar-init" ""
  '';

  buildInputs = [ json_c libpcap ncurses libtirpc ];
  nativeBuildInputs = [ cmake ];

  # To build with GCC 8+ it needs:
  CXXFLAGS = "-Wno-class-memaccess -Wno-ignored-qualifiers";
  # CMake can't find json_c without:
  NIX_CFLAGS_COMPILE = [ "-I${json_c.dev}/include/json-c" "-Wno-error=address-of-packed-member" "-I${libtirpc.dev}/include/tirpc" ];
  NIX_LDFLAGS = [ "-ltirpc" ];

  doCheck = false; # requires network access

  meta = with lib; {
    homepage = "http://epam.github.io/nfstrace/";
    description = "NFS and CIFS tracing/monitoring/capturing/analyzing tool";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
