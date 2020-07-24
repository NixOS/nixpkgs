{ fetchurl, stdenv, openjdk, unzip, makeWrapper }:

let
  version = "1.4.9";
in stdenv.mkDerivation {
  pname = "gogui";
  inherit version;
  buildInputs = [ unzip makeWrapper ];
  src = fetchurl {
    url = "mirror://sourceforge/project/gogui/gogui/${version}/gogui-${version}.zip";
    sha256 = "0qk6p1bhi1816n638bg11ljyj6zxvm75jdf02aabzdmmd9slns1j";
  };
  dontConfigure = true;
  installPhase = ''
    mkdir -p $out/share/doc
    mv -vi {bin,lib} $out/
    mv -vi doc $out/share/doc/gogui
    for x in $out/bin/*; do
      wrapProgram $x --prefix PATH ":" ${openjdk}/bin
    done
  '';
  meta = {
    maintainers = [ stdenv.lib.maintainers.cleverca22 ];
    description = "A graphical user interface to programs that play the board game Go and support the Go Text Protocol such as GNU Go";
    homepage = "http://gogui.sourceforge.net/";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl3;
  };
}
