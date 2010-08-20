{ stdenv, fetchurl, libsigsegv }:

stdenv.mkDerivation rec {
  name = "gawk-3.1.8";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.bz2";
    sha256 = "1d0jfh319w4h8l1zzqv248916wrc2add1b1aghri31rj9hn7pg2x";
  };

  doCheck = true;

  buildInputs = [ libsigsegv ];

  configureFlags = [ "--with-libsigsegv-prefix=${libsigsegv}" ];

  meta = {
    homepage = http://www.gnu.org/software/gawk/;
    description = "GNU implementation of the Awk programming language";

    longDescription = ''
      Many computer users need to manipulate text files: extract and then
      operate on data from parts of certain lines while discarding the rest,
      make changes in various text files wherever certain patterns appear,
      and so on.  To write a program to do these things in a language such as
      C or Pascal is a time-consuming inconvenience that may take many lines
      of code.  The job is easy with awk, especially the GNU implementation:
      Gawk.

      The awk utility interprets a special-purpose programming language that
      makes it possible to handle many data-reformatting jobs with just a few
      lines of code.
    '';

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
