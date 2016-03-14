{stdenv, fetchurl, tex}:

stdenv.mkDerivation rec{

  name = "nuweb-${version}";
  version = "1.58";

  src = fetchurl {
    url = "mirror://sourceforge/project/nuweb/${name}.tar.gz";
    sha256 = "0q51i3miy15fv4njjp82yws01qfjxvqx5ly3g3vh8z3h7iq9p47y";
  };

  buildInputs = [ tex ];

  patchPhase = ''
    sed -ie 's|nuweb -r|./nuweb -r|' Makefile
  '';
  buildPhase = ''
    make nuweb
    make nuweb.pdf nuwebdoc.pdf all
  '';
  installPhase = ''
    install -d $out/bin $out/share/man/man1 $out/share/doc/${name} $out/share/emacs/site-lisp
    cp nuweb $out/bin
    cp nuweb.el $out/share/emacs/site-lisp
    gzip -c nuweb.1 > $out/share/man/man1/nuweb.1.gz
    cp htdocs/index.html nuweb.w nuweb.pdf nuwebdoc.pdf README $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    description = "A simple literate programming tool";
    homepage = http://nuweb.sourceforge.net;
    license = licenses.free;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
# TODO: nuweb.el Emacs integration
