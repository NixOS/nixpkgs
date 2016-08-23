{stdenv, fetchurl, unzip, python, makeWrapper, ghostscript, pngnq, pillow, djvulibre
, optipng, unrar}:

stdenv.mkDerivation {
  name = "pdfread-1.8.2";

  src = fetchurl {
    # I got it from http://www.mobileread.com/forums/showthread.php?t=21906
    # But that needs user registration to allow downloading.
    # This is an evolution from pdfread 1.7 in http://pdfread.sourceforge.net/
    # Temporary place:
    url = http://vicerveza.homeunix.net/~viric/soft/PDFRead-1.8.2-Source-noGUI-noInstaller.zip;
    sha256 = "0mzxpnk97f0ww5ds7h4wsval3g4lnrhv6rhspjs7cy4i41gmk8an";
  };

  buildInputs = [ unzip python makeWrapper ];

  broken = true; # Not found.

  phases = "unpackPhase patchPhase installPhase";

  unpackPhase = ''
    unzip $src
    sourceRoot=`pwd`/PDFRead/src
  '';

  patchPhase = ''
    sed -i 's,#!/usr.*,#!${python}/bin/python,' pdfread.py
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp pdfread.py $out/bin
    chmod +x $out/bin/pdfread.py

    LIBSUFFIX=lib/${python.libPrefix}/site-packages/
    PYDIR=$out/$LIBSUFFIX
    mkdir -p $PYDIR
    cp -R *.py pylrs $PYDIR

    wrapProgram $out/bin/pdfread.py --prefix PYTHONPATH : $PYTHONPATH:${pillow}/$LIBSUFFIX/PIL:$PYDIR \
      --prefix PATH : ${stdenv.lib.makeBinPath [ ghostscript pngnq djvulibre unrar optipng ]}
  '';

  meta = with stdenv.lib; {
    description = "PDF/DJVU to ebook format converter";
    homepage = http://www.mobileread.com/forums/showthread.php?t=21906;
    license = licenses.mit;
  };
}
