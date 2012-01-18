args: with args;

rec {
  name = "texlive-pgf-2007";

  src = fetchurl {
    url = "mirror://sourceforge/pgf/pgf-2.00.tar.gz";
    sha256 = "0j57niag4jb2k0iyrvjsannxljc3vkx0iag7zd35ilhiy4dh6264";
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
