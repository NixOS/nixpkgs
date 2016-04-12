{ stdenv, fetchurl, lzip }:

stdenv.mkDerivation rec {
  name = "ddrescue-1.21";

  src = fetchurl {
    url = "mirror://gnu/ddrescue/${name}.tar.lz";
    sha256 = "1b71hb42lh33y9843nd1mxlwkk9qh9ajvnz6ivzd1jq9lav4x7ph";
  };

  buildInputs = [ lzip ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GNU ddrescue, a data recovery tool";

    longDescription =
      '' GNU ddrescue is a data recovery tool.  It copies data from one file
         or block device (hard disc, cdrom, etc) to another, trying hard to
         rescue data in case of read errors.

         The basic operation of ddrescue is fully automatic.  That is, you
         don't have to wait for an error, stop the program, read the log, run
         it in reverse mode, etc.

         If you use the logfile feature of ddrescue, the data is rescued very
         efficiently (only the needed blocks are read).  Also you can
         interrupt the rescue at any time and resume it later at the same
         point.

         Automatic merging of backups: If you have two or more damaged copies
         of a file, cdrom, etc, and run ddrescue on all of them, one at a
         time, with the same output file, you will probably obtain a complete
         and error-free file.  This is so because the probability of having
         damaged areas at the same places on different input files is very
         low.  Using the logfile, only the needed blocks are read from the
         second and successive copies.
      '';

    homepage = http://www.gnu.org/software/ddrescue/ddrescue.html;

    license = licenses.gpl3Plus;

    platforms = platforms.all;
    maintainers = with maintainers; [ iElectric fpletz ];
  };
}
