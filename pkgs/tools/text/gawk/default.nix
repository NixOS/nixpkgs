{ stdenv, fetchurl, libsigsegv, readline, readlineSupport ? false }:

stdenv.mkDerivation rec {
  name = "gawk-4.1.1";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.xz";
    sha256 = "1nz83vpss8xv7m475sv4qhhj40g74nvcw0y9kwq9ds8wzfmcdm7g";
  };

  # Currently broken due to locale tests failing
  #doCheck = !stdenv.isCygwin; # XXX: `test-dup2' segfaults on Cygwin 6.1

  buildInputs = [ libsigsegv ]
    ++ stdenv.lib.optional readlineSupport readline;

  configureFlags = [ "--with-libsigsegv-prefix=${libsigsegv}" ]
    ++ stdenv.lib.optional readlineSupport "--with-readline=${readline}"
      # only darwin where reported, seems OK on non-chrooted Fedora (don't rebuild stdenv)
    ++ stdenv.lib.optional (!readlineSupport && stdenv.isDarwin) "--without-readline";

  postInstall = "rm $out/bin/gawk-*";

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

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
  };
}
