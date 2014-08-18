{ stdenv, fetchurl, python, libxslt, tetex
, enableAllFeatures ? false, imagemagick ? null, transfig ? null, inkscape ? null, fontconfig ? null, ghostscript ? null }:

# NOTE: enableAllFeatures just purifies the expression, it doesn't actually
# enable any extra features.

assert enableAllFeatures ->
  imagemagick != null &&
  transfig != null &&
  inkscape != null &&
  fontconfig != null &&
  ghostscript != null;

stdenv.mkDerivation rec {
  name = "dblatex-0.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/dblatex/${name}.tar.bz2";
    sha256 = "120w3wm07qx0k1grgdhjwm2vpwil71icshjvqznskp1f6ggch290";
  };

  buildInputs = [ python libxslt tetex ]
    ++ stdenv.lib.optionals enableAllFeatures [ imagemagick transfig ];

  # TODO: dblatex tries to execute texindy command, but nixpkgs doesn't have
  # that yet. In Ubuntu, texindy is a part of the xindy package.
  preConfigure = ''
    sed -i 's|self.install_layout == "deb"|False|' setup.py
  '' + stdenv.lib.optionalString enableAllFeatures ''
    for file in $(find -name "*.py"); do
        sed -e 's|cmd = \["xsltproc|cmd = \["${libxslt}/bin/xsltproc|g' \
            -e 's|Popen(\["xsltproc|Popen(\["${libxslt}/bin/xsltproc|g' \
            -e 's|cmd = \["texindy|cmd = ["nixpkgs_is_missing_texindy|g' \
            -e 's|cmd = "epstopdf|cmd = "${tetex}/bin/epstopdf|g' \
            -e 's|cmd = \["makeindex|cmd = ["${tetex}/bin/makeindex|g' \
            -e 's|doc.program = "pdflatex"|doc.program = "${tetex}/bin/pdflatex"|g' \
            -e 's|self.program = "latex"|self.program = "${tetex}/bin/latex"|g' \
            -e 's|Popen("pdflatex|Popen("${tetex}/bin/pdflatex|g' \
            -e 's|"fc-match"|"${fontconfig}/bin/fc-match"|g' \
            -e 's|"fc-list"|"${fontconfig}/bin/fc-list"|g' \
            -e 's|cmd = "inkscape|cmd = "${inkscape}/bin/inkscape|g' \
            -e 's|cmd = "fig2dev|cmd = "${transfig}/bin/fig2dev|g' \
            -e 's|cmd = \["ps2pdf|cmd = ["${ghostscript}/bin/ps2pdf|g' \
            -e 's|cmd = "convert|cmd = "${imagemagick}/bin/convert|g' \
            -i "$file"
    done
  '';

  buildPhase = "true";
  
  installPhase = ''
    python ./setup.py install --prefix="$out" --use-python-path --verbose
  '';

  meta = {
    description = "A program to convert DocBook to DVI, PostScript or PDF via LaTeX or ConTeXt";
    homepage = http://dblatex.sourceforge.net/;
    license = "GPL";
  };
}
