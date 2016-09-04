{ stdenv, fetchurl, libX11, libXtst, xextproto, libXi, inputproto }:

stdenv.mkDerivation {
  name = "xmacro-0.3pre20000911";

  src = fetchurl {
    url = mirror://sourceforge/xmacro/xmacro-pre0.3-20000911.tar.gz;
    sha256 = "04gzgxhp8bx98zrcvmsm7mn72r9g9588skbf64cqvkp4yz6kfqhb";
  };

  preBuild = ''
    sed -e 's/-pedantic//g' -i Makefile
    sed -e 's/iostream[.]h/iostream/' -i *.cpp
    sed -e 's/iomanip[.]h/iomanip/' -i *.cpp
    sed -e '1iusing namespace std;' -i *.cpp
  '';

  preInstall = "echo -e 'install:\n	mkdir \${out}/bin;\n	cp xmacrorec xmacrorec2 xmacroplay \${out}/bin;' >>Makefile; ";

  buildInputs = [ libX11 libXtst xextproto libXi inputproto ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
