{ stdenv, fetchurl, python, libxslt, texlive
, enableAllFeatures ? false, imagemagick ? null, transfig ? null, inkscape ? null, fontconfig ? null, ghostscript ? null

, tex ? texlive.combine { # satisfy all packages that ./configure mentions
    inherit (texlive) scheme-basic epstopdf anysize appendix changebar
      fancybox fancyvrb float footmisc listings jknapltx/*for mathrsfs.sty*/
      multirow overpic pdfpages graphics stmaryrd subfigure titlesec wasysym
      # pkgs below don't seem requested by dblatex, but our manual fails without them
      ec zapfding symbol eepic times rsfs cs tex4ht courier helvetic ly1;
  }
}:

# NOTE: enableAllFeatures just purifies the expression, it doesn't actually
# enable any extra features.

assert enableAllFeatures ->
  imagemagick != null &&
  transfig != null &&
  inkscape != null &&
  fontconfig != null &&
  ghostscript != null;

stdenv.mkDerivation rec {
  name = "dblatex-0.3.7";

  src = fetchurl {
    url = "mirror://sourceforge/dblatex/${name}.tar.bz2";
    sha256 = "0bkjgrn03dy5c7438s429wnv6z5ynxkr4pbhp2z49kynskgkzkjr";
  };

  buildInputs = [ python libxslt tex ]
    ++ stdenv.lib.optionals enableAllFeatures [ imagemagick transfig ];

  # TODO: dblatex tries to execute texindy command, but nixpkgs doesn't have
  # that yet. In Ubuntu, texindy is a part of the xindy package.
  preConfigure = ''
    sed -i 's|self.install_layout == "deb"|False|' setup.py
  '' + stdenv.lib.optionalString enableAllFeatures ''
    for file in $(find -name "*.py"); do
        sed -e 's|cmd = \["xsltproc|cmd = \["${libxslt.bin}/bin/xsltproc|g' \
            -e 's|Popen(\["xsltproc|Popen(\["${libxslt.bin}/bin/xsltproc|g' \
            -e 's|cmd = \["texindy|cmd = ["nixpkgs_is_missing_texindy|g' \
            -e 's|cmd = "epstopdf|cmd = "${tex}/bin/epstopdf|g' \
            -e 's|cmd = \["makeindex|cmd = ["${tex}/bin/makeindex|g' \
            -e 's|doc.program = "pdflatex"|doc.program = "${tex}/bin/pdflatex"|g' \
            -e 's|self.program = "latex"|self.program = "${tex}/bin/latex"|g' \
            -e 's|Popen("pdflatex|Popen("${tex}/bin/pdflatex|g' \
            -e 's|"fc-match"|"${fontconfig.bin}/bin/fc-match"|g' \
            -e 's|"fc-list"|"${fontconfig.bin}/bin/fc-list"|g' \
            -e 's|cmd = "inkscape|cmd = "${inkscape}/bin/inkscape|g' \
            -e 's|cmd = "fig2dev|cmd = "${transfig}/bin/fig2dev|g' \
            -e 's|cmd = \["ps2pdf|cmd = ["${ghostscript}/bin/ps2pdf|g' \
            -e 's|cmd = "convert|cmd = "${imagemagick.out}/bin/convert|g' \
            -i "$file"
    done
  '';

  dontBuild = true;

  installPhase = ''
    python ./setup.py install --prefix="$out" --use-python-path --verbose
  '';

  passthru = { inherit tex; };

  meta = {
    description = "A program to convert DocBook to DVI, PostScript or PDF via LaTeX or ConTeXt";
    homepage = http://dblatex.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
