{ fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "rush";
  version = "2.1.90";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-qy95gDXVphNn486q/dcVynFHk/WNYgEtXk2Kn1eRxww=";
  };

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

    homepage = "https://www.gnu.org/software/rush/";
    license = lib.licenses.gpl3Plus;

    maintainers = [ lib.maintainers.bjg ];
    platforms = lib.platforms.all;
  };

  passthru = {
    shellPath = "/bin/rush";
  };
}
