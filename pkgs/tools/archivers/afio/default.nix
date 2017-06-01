{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  version = "2.5.1";
  name = "afio-${version}";

  src = fetchurl {
    url = "http://members.chello.nl/~k.holtman/${name}.tgz";
    sha256 = "363457a5d6ee422d9b704ef56d26369ca5ee671d7209cfe799cab6e30bf2b99a";
  };

  /*
   * A patch to simplify the installation and for removing the
   * hard coded dependency on GCC.
   */
  patches = [ ./afio-2.5.1-install.patch ];

  installFlags = "DESTDIR=$(out)";

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
