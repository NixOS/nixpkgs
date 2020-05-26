{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "kore";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "jorisvink";
    repo = pname;
    rev = "${version}-release";
    sha256 = "0jlvry9p1f7284cscfsg04ngbaq038yx3nz815jcr5s3d2jzps3h";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # added to fix build w/gcc7 and clang5
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isGNU "-Wno-error=pointer-compare"
    + stdenv.lib.optionalString stdenv.cc.isClang " -Wno-error=unknown-warning-option";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An easy to use web application framework for C";
    homepage = "https://kore.io";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ johnmh ];
  };
}
