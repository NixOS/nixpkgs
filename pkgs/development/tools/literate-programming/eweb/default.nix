{ stdenv, fetchurl, python3, asciidoc }:

stdenv.mkDerivation rec{

  name = "eweb-${meta.version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/eweb/${name}.tar.bz2";
    sha256 = "1xy7vm2sj5q6s620fm25klmnwnz9xkrxmx4q2f8h6c85ydisayd5";
  };

  buildInputs = [ python3 asciidoc ];

  installPhase = ''
    install -d $out/bin $out/share/doc/${name}
    cp etangle.py $out/bin
    cp etangle.w etangle.html $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    version = "9.10" ;
    homepage = http://eweb.sf.net;
    description = "An Asciidoc-based literate programming tool, written in Python";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
