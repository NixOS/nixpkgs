{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "gawk-3.1.7";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.bz2";
    sha256 = "0wfyiqc28cxb5wjbdph4y33h1fdf56nj6cm7as546niwjsw7cazi";
  };

  doCheck = true;

  # The libsigsegv provided with gawk has failing tests:
  # I did like in Fedora:
  # http://rpmfind.net//linux/RPM/fedora/devel/i386/gawk-3.1.7-2.fc13.i686.html
  configureFlags = "--disable-libsigsegv";

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
