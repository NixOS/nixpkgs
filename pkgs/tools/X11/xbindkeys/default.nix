{ stdenv, fetchurl, libX11, guile }:

let version = "1.8.5"; in
stdenv.mkDerivation {
  name = "xbindkeys-${version}";
  src = fetchurl {
    url = "http://www.nongnu.org/xbindkeys/xbindkeys-${version}.tar.gz";
    sha256 = "10gwyvj69yyqgk1xxbrl37gx3c3jfpgr92mz62b1x5q6jiq7hbyn";
  };

  buildInputs = [ libX11 guile ];

  meta = {
    homepage = http://www.nongnu.org/xbindkeys/xbindkeys.html;
    description = "Launch shell commands with your keyboard or your mouse under X Window";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
