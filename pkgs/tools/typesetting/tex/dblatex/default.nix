{ lib, stdenv, fetchurl, python3, libxslt, texliveBasic
, enableAllFeatures ? false, imagemagick, fig2dev, inkscape, fontconfig, ghostscript

, tex ? texliveBasic.withPackages (ps: with ps; [ # satisfy all packages that ./configure mentions
    epstopdf anysize appendix changebar
    fancybox fancyvrb float footmisc listings jknapltx/*for mathrsfs.sty*/
    multirow overpic pdfpages pdflscape graphics stmaryrd subfigure titlesec wasysym
    # pkgs below don't seem requested by dblatex, but our manual fails without them
    ec zapfding symbol eepic times rsfs cs tex4ht courier helvetic ly1
  ])
}:

# NOTE: enableAllFeatures just purifies the expression, it doesn't actually
# enable any extra features.

stdenv.mkDerivation rec {
  pname = "dblatex${lib.optionalString enableAllFeatures "-full"}";
  version = "0.3.12";

  src = fetchurl {
    url = "mirror://sourceforge/dblatex/${pname}3-${version}.tar.bz2";
    sha256 = "0yd09nypswy3q4scri1dg7dr99d7gd6r2dwx0xm81l9f4y32gs0n";
  };

  buildInputs = [ python3 libxslt tex ]
    ++ lib.optionals enableAllFeatures [ imagemagick fig2dev ];

  # TODO: dblatex tries to execute texindy command, but nixpkgs doesn't have
  # that yet. In Ubuntu, texindy is a part of the xindy package.
  preConfigure = ''
    sed -i 's|self.install_layout == "deb"|False|' setup.py
  '' + lib.optionalString enableAllFeatures ''
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
            -e 's|cmd = "fig2dev|cmd = "${fig2dev}/bin/fig2dev|g' \
            -e 's|cmd = \["ps2pdf|cmd = ["${ghostscript}/bin/ps2pdf|g' \
            -e 's|cmd = "convert|cmd = "${imagemagick.out}/bin/convert|g' \
            -i "$file"
    done
  '';

  dontBuild = true;

  installPhase = ''
    ${python3.interpreter} ./setup.py install --prefix="$out" --use-python-path --verbose
  '';

  passthru = { inherit tex; };

  meta = {
    description = "Program to convert DocBook to DVI, PostScript or PDF via LaTeX or ConTeXt";
    mainProgram = "dblatex";
    homepage = "https://dblatex.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
