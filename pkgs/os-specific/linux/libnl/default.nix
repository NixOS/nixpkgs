{ stdenv, fetchFromGitHub, autoreconfHook, bison, flex, pkgconfig }:

let version = "3.2.28"; in
stdenv.mkDerivation {
  name = "libnl-${version}";

  src = fetchFromGitHub {
    sha256 = "02cm57z4h7rhjlxza07zhk02924acfz6m5gbmm5lbkkp6qh81328";
    rev = "libnl3_2_28";
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
