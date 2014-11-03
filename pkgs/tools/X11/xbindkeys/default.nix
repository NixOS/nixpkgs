{ stdenv, fetchurl, libX11, guile }:

let version = "1.8.6"; in
stdenv.mkDerivation {
  name = "xbindkeys-${version}";
  src = fetchurl {
    url = "http://www.nongnu.org/xbindkeys/xbindkeys-${version}.tar.gz";
    sha256 = "060df6d8y727jp1inp7blp44cs8a7jig7vcm8ndsn6gw36z1h3bc";
  };

  buildInputs = [ libX11 guile ];

  meta = {
    homepage = http://www.nongnu.org/xbindkeys/xbindkeys.html;
    description = "Launch shell commands with your keyboard or your mouse under X Window";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
