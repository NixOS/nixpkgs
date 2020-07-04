{ stdenv, fetchurl, pkgconfig, libX11, guile }:

let version = "1.8.7"; in
stdenv.mkDerivation {
  pname = "xbindkeys";
  inherit version;
  src = fetchurl {
    url = "https://www.nongnu.org/xbindkeys/xbindkeys-${version}.tar.gz";
    sha256 = "1wl2vc5alisiwyk8m07y1ryq8w3ll9ym83j27g4apm4ixjl8d6x2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 guile ];

  meta = {
    homepage = "https://www.nongnu.org/xbindkeys/xbindkeys.html";
    description = "Launch shell commands with your keyboard or your mouse under X Window";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
