{ stdenv, fetchFromGitHub, autoreconfHook, bison, flex, pkgconfig }:

let version = "3.2.29"; in
stdenv.mkDerivation {
  name = "libnl-${version}";

  src = fetchFromGitHub {
    sha256 = "0y8fcb1bfbdvxgckq5p6l4jzx0kvv3g11svy6d5v3i6zy9kkq8wh";
    rev = "libnl3_2_29";
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
