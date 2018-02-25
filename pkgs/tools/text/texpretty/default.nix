{ stdenv, fetchurl, perl, nettools, texinfo, bison, flex
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "texpretty-${version}";
  version = "0.02";

  src = fetchurl {
    sha256 = "1ixnlwz0hzqx9mync630pd5gh26mdlz1ah9mr5qjz1b0gpl0p9sm";
    url = http://ftp.math.utah.edu/pub/texpretty/texpretty-0.02.tar.gz;
  };

  buildInputs = [ nettools perl texinfo bison flex pkgconfig ];

  postUnpack = ''
    mkdir -p $out/bin $out/man/man1
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "TeX prettyprinter";
    homepage = http://ftp.math.utah.edu/pub/texpretty/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ logarytm ];

    longDescription = ''
      texpretty filters its TeX input from stdin, or from one or more files
      named on the command line, and prettyprints it to stdout.  Most
      formatting systems based on TeX, including AmSTeX, AmSLaTeX, ETeX (K.
      Berry's Extended plain TeX), LAmSTeX, LaTeX, and SliTeX, are handled
      reasonably well.  texpretty also includes support for the Free Software
      Foundation's GNU Project TeXinfo, whose markup syntax resembles that of
      scribe(1) rather than that of TeX.
    '';
  };
}
