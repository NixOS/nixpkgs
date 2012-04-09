{ fetchurl, stdenv, libcdio, zlib, bzip2, readline, acl }:

stdenv.mkDerivation rec {
  name = "xorriso-1.2.2";

  src = fetchurl {
    url = "mirror://gnu/xorriso/${name}.tar.gz";
    sha256 = "0kw4fiqn24vya3zhay6minzrbz10zlxm8sjs272z7l5s2kwcjypx";
  };

  doCheck = true;

  buildInputs = [ libcdio zlib bzip2 readline ]
    ++ stdenv.lib.optional stdenv.isLinux acl;

  meta = {
    description = "GNU xorriso, an ISO 9660 Rock Ridge file system manipulator";

    longDescription =
      '' GNU xorriso copies file objects from POSIX compliant filesystems
         into Rock Ridge enhanced ISO 9660 filesystems and allows
         session-wise manipulation of such filesystems.  It can load the
         management information of existing ISO images and it writes the
         session results to optical media or to filesystem objects.  Vice
         versa xorriso is able to copy file objects out of ISO 9660
         filesystems.
      '';

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/xorriso/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.unix;
  };
}
