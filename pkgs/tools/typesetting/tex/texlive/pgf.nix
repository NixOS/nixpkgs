args: with args;


rec {
  name = "texlive-pgf-2010";

  src = fetchurl {
    url = "mirror://debian/pool/main/p/pgf/pgf_2.10.orig.tar.gz";
    sha256 = "087i0fya6z42wmw7xlj3kyi3bwjg0avpxb01v4xy7ycxnkk94834";
  };

  propagatedBuildInputs = [texLiveLatexXColor texLive];

  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/share/
    mkdir -p $out/texmf/tex/generic/pgf
    cp -r * $out/texmf/tex/generic/pgf
    ln -s $out/texmf* $out/share/
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive: graphics package";

    longDescription = ''
      PGF is a macro package for creating graphics.  It is platform-
      and format-independent and works together with the most
      important TeX backend drivers, including pdftex and dvips.  It
      comes with a user-friedly syntax layer called TikZ.

      Its usage is similar to pstricks and the standard picture
      environment.  PGF works with plain (pdf-)TeX, (pdf-)LaTeX, and
      ConTeXt.  Unlike pstricks , it can produce either PostScript or
      PDF output.
    '';

    license = [ "GPLv2" "LPPLv1.3c" ];

    homepage = http://tug.ctan.org/tex-archive/graphics/pgf/;
  };
}
