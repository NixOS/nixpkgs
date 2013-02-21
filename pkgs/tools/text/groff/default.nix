{ stdenv, fetchurl, ghostscript, perl, groff }:

stdenv.mkDerivation rec {
  name = "groff-1.22.2";

  src = fetchurl {
    url = "mirror://gnu/groff/${name}.tar.gz";
    sha256 = "0xi07nhj5vdgax37rj25mwxzdmsz1ifx50hjgc6hqbkpqkd6821q";
  };

  buildInputs = [ ghostscript ];
  nativeBuildInputs = [ perl ];

  doCheck = true;

  crossAttrs = {
    # Trick to get the build system find the proper 'native' groff
    # http://www.mail-archive.com/bug-groff@gnu.org/msg01335.html
    preBuild = ''
      makeFlags="GROFF_BIN_PATH=${groff}/bin GROFFBIN=${groff}/bin/groff"
    '';
  };

  meta = {
    homepage = "http://www.gnu.org/software/groff/";
    description = "GNU Troff, a typesetting package that reads plain text and produces formatted output";
    license = "GPLv3+";

    longDescription = ''
      groff is the GNU implementation of troff, a document formatting
      system.  Included in this release are implementations of troff,
      pic, eqn, tbl, grn, refer, -man, -mdoc, -mom, and -ms macros,
      and drivers for PostScript, TeX dvi format, HP LaserJet 4
      printers, Canon CAPSL printers, HTML and XHTML format (beta
      status), and typewriter-like devices.  Also included is a
      modified version of the Berkeley -me macros, the enhanced
      version gxditview of the X11 xditview previewer, and an
      implementation of the -mm macros.
    '';
  };
}
