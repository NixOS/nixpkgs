{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "rush-1.7";

  src = fetchurl {
    url = "mirror://gnu/rush/${name}.tar.gz";
    sha256 = "0fh0gbbp0iiq3wbkf503xb40r8ljk42vyj9bnlflbz82d6ipy1rm";
  };

  patches = [ ./gets.patch ];

  doCheck = true;

  meta = {
    description = "Restricted User Shell";

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
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };

  passthru = {
    shellPath = "/bin/rush";
  };
}
