{ stdenv, fetchurl, libsigsegv }:

stdenv.mkDerivation rec {
  name = "gawk-4.0.1";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.xz";
    sha256 = "0iyb5qpj27qwa4h3617ymjhbc7vxvb82dlgw2vrnss40mjhbj35f";
  };

  patches = stdenv.lib.optional stdenv.isCygwin [ ./cygwin-identifiers.patch ];

  doCheck = !stdenv.isCygwin; # XXX: `test-dup2' segfaults on Cygwin 6.1

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
