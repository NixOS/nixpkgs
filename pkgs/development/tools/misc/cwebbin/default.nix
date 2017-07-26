{ stdenv, fetchFromGitHub, fetchurl, tie }:

stdenv.mkDerivation rec {
  name = "cwebbin-${version}";
  version = "22p";

  src = fetchFromGitHub {
    owner = "ascherer";
    repo = "cwebbin";
    rev = "2016-05-20-22p";
    sha256 = "0zf93016hm9i74i2v384rwzcw16y3hg5vc2mibzkx1rzvqa50yfr";
  };

  cweb = fetchurl {
    url = https://www.ctan.org/tex-archive/web/c_cpp/cweb/cweb-3.64ah.tgz;
    sha256 = "1hdzxfzaibnjxjzgp6d2zay8nsarnfy9hfq55hz1bxzzl23n35aj";
  };

  buildInputs = [ tie ];

  makeFlags = [
    "MACROSDIR=$(out)/share/texmf/tex/generic/cweb"
    "CWEBINPUTS=$(out)/lib/cweb"
    "DESTDIR=$(out)/bin/"
    "MANDIR=$(out)/share/man/man1"
    "EMACSDIR=$(out)/share/emacs/site-lisp"
    "CP=cp"
    "RM=rm"
    "PDFTEX=echo"
    "CC=c++"
  ];

  buildPhase = ''
    zcat ${cweb} | tar -xvpf -
    make -f Makefile.unix boot $makeFlags
    make -f Makefile.unix cautiously $makeFlags
  '';

  installPhase = ''
    mkdir -p $out/share/man/man1 $out/share/texmf/tex/generic $out/share/emacs $out/lib
    make -f Makefile.unix install $makeFlags
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Literate Programming in C/C++";
    platforms = with platforms; unix;
    maintainers = with maintainers; [ vrthra ];
  };
}
