{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "enscript-1.6.6";

  src = fetchurl {
    url = "mirror://gnu/enscript/${name}.tar.gz";
    sha256 = "1fy0ymvzrrvs889zanxcaxjfcxarm2d3k43c9frmbl1ld7dblmkd";
  };

  preBuild =
    ''
      # Fix building on Darwin with GCC.
      substituteInPlace compat/regex.c --replace \
         __private_extern__  '__attribute__ ((visibility ("hidden")))'
    '';

  buildInputs = [ gettext ];

  doCheck = true;

  meta = {
    description = "Converter from ASCII to PostScript, HTML, or RTF";

    longDescription =
      '' GNU Enscript converts ASCII files to PostScript, HTML, or RTF and
         stores generated output to a file or sends it directly to the
         printer.  It includes features for `pretty-printing'
         (language-sensitive code highlighting) in several programming
         languages.

         Enscript can be easily extended to handle different output media and
         it has many options that can be used to customize printouts.
      '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = https://www.gnu.org/software/enscript/;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
