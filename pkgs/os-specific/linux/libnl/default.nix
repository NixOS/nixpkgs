{ stdenv, fetchFromGitHub, autoreconfHook, bison, flex, pkgconfig }:

let version = "3.2.26"; in
stdenv.mkDerivation {
  name = "libnl-${version}";

  src = fetchFromGitHub {
    sha256 = "1cbqdhirn6hxmv8xkm8xp3n6ayyxw7sbi15fym167rdz0h9rkhmm";
    rev = "libnl3_2_26";
    repo = "libnl";
    owner = "thom311";
  };

  outputs = [ "dev" "bin" "out" "man" ];

  nativeBuildInputs = [ autoreconfHook bison flex pkgconfig ];

  meta = {
    inherit version;
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
