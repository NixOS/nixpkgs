{ stdenv, fetchurl, libsigsegv }:

stdenv.mkDerivation (rec {
  name = "gawk-4.0.2";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.xz";
    sha256 = "21e1f28c51b5160f0a4bf1a735c6109b46a3bd6a43de808eabc21c17bb026d13";
  };

  doCheck = !stdenv.isCygwin;      # XXX: `test-dup2' segfaults on Cygwin 6.1

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

//

stdenv.lib.optionalAttrs stdenv.isCygwin {
  patches = [ ./cygwin-identifiers.patch ];
})
