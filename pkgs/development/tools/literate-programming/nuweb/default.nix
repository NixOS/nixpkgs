{stdenv, fetchurl, tex}:

stdenv.mkDerivation rec{

  pname = "nuweb";
  version = "1.60";

  src = fetchurl {
    url = "mirror://sourceforge/project/nuweb/${pname}-${version}.tar.gz";
    sha256 = "08xmwq48biy2c1fr8wnyknyvqs9jfsj42cb7fw638xqv35f0xxvl";
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
    install -d $out/bin $out/share/man/man1 $out/share/doc/${pname}-${version} $out/share/emacs/site-lisp
    cp nuweb $out/bin
    cp nuweb.el $out/share/emacs/site-lisp
    gzip -c nuweb.1 > $out/share/man/man1/nuweb.1.gz
    cp htdocs/index.html nuweb.w nuweb.pdf nuwebdoc.pdf README $out/share/doc/${pname}-${version}
  '';

  meta = with stdenv.lib; {
    description = "A simple literate programming tool";
    homepage = "http://nuweb.sourceforge.net";
    license = licenses.free;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: nuweb.el Emacs integration
