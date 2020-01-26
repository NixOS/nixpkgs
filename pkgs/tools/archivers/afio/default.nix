{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  version = "2.5.2";
  pname = "afio";

  src = fetchurl {
    url = "http://members.chello.nl/~k.holtman/${pname}-${version}.tgz";
    sha256 = "1fa29wlqv76hzf8bxp1qpza1r23pm2f3m7rcf0jpwm6z150s2k66";
  };

  /*
   * A patch to simplify the installation and for removing the
   * hard coded dependency on GCC.
   */
  patches = [ ./0001-makefile-fix-installation.patch ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = {
    homepage = http://members.chello.nl/~k.holtman/afio.html;
    description = "Fault tolerant cpio archiver targeting backups";
    platforms = stdenv.lib.platforms.all;
    /*
     * Licensing is complicated due to the age of the code base, but
     * generally free. See the file ``afio_license_issues_v5.txt`` for
     * a comprehensive discussion.
     */
    license = stdenv.lib.licenses.free;
  };
}
