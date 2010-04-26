{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "rush-1.6";

  src = fetchurl {
    url = "mirror://gnu/rush/${name}.tar.gz";
    sha256 = "1j9h1imql05cijav6hr9jigcmy1br8fs9vahvh6y7pf53k4lcfrv";
  };

  doCheck = true;

  meta = {
    description = "GNU Rush, Restricted User Shell";

    longDescription =
      '' GNU Rush is a Restricted User Shell, designed for sites
         providing limited remote access to their resources, such as
         svn or git repositories, scp, or the like.  Using a
         sophisticated configuration file, Rush gives you complete
         control over the command lines that users execute, as well as
         over the usage of system resources, such as virtual memory,
         CPU time, etc.

         In particular, it allows remote programs to be run in a chrooted
         environment, which is important with such programs as
         sftp-server or scp, that lack this ability.
      '';

    homepage = http://www.gnu.org/software/rush/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
