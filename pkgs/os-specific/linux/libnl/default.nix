{ stdenv, fetchFromGitHub, autoreconfHook, bison, flex, pkgconfig }:

let version = "3.2.29"; in
stdenv.mkDerivation {
  name = "libnl-${version}";

  src = fetchFromGitHub {
    sha256 = "1078sbfgcb6ijal9af6lv26sy233wq14afyrc4bkdbnfl0zgsbwi";
    rev = "libnl3_2_23";
    repo = "libnl";
    owner = "thom311";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  nativeBuildInputs = [ autoreconfHook bison flex pkgconfig ];

  meta = {
    inherit version;
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
