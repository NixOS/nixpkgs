{ stdenv, fetchFromGitHub, autoreconfHook, bison, flex, pkgconfig }:

let version = "3.2.27"; in
stdenv.mkDerivation {
  name = "libnl-${version}";

  src = fetchFromGitHub {
    sha256 = "1rc8plgl2ijq2pwlzinpfr06kiggjyx71r3lw505m6rvxvdac82r";
    rev = "libnl3_2_27";
    repo = "libnl";
    owner = "thom311";
  };

  nativeBuildInputs = [ autoreconfHook bison flex pkgconfig ];

  meta = {
    inherit version;
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
