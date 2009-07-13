{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "global-5.7.5";

  src = fetchurl {
    url = "mirror://gnu/global/${name}.tar.gz";
    sha256 = "0fdkkg5qs76cjdnig54bhw97dgwg2rm2dg8k8r7hz836pk838540";
  };

  meta = {
    description = "GNU GLOBAL source code tag system";

    longDescription = ''
      GNU GLOBAL is a source code tagging system that works the same way
      across diverse environments (Emacs, vi, less, Bash, web browser, etc).
      You can locate specified objects in source files and move there easily.
      It is useful for hacking a large project containing many
      subdirectories, many #ifdef and many main() functions.  It is similar
      to ctags or etags but is different from them at the point of
      independence of any editor.  It runs on a UNIX (POSIX) compatible
      operating system like GNU and BSD.
    '';

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/global/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
