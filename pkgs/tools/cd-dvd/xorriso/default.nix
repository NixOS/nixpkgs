{ fetchurl, stdenv, libcdio, zlib, bzip2, readline, acl, attr }:

stdenv.mkDerivation rec {
  name = "xorriso-1.4.2";

  src = fetchurl {
    url = "mirror://gnu/xorriso/${name}.tar.gz";
    sha256 = "1cq4a0904lnz6nygbgarnlq49cz4qnfdyvz90s3nfk5as7gbwhr8";
  };

  doCheck = true;

  buildInputs = [ libcdio zlib bzip2 readline attr ]
    ++ stdenv.lib.optional stdenv.isLinux acl;

  meta = {
    description = "ISO 9660 Rock Ridge file system manipulator";

    longDescription =
      '' GNU xorriso copies file objects from POSIX compliant filesystems
         into Rock Ridge enhanced ISO 9660 filesystems and allows
         session-wise manipulation of such filesystems.  It can load the
         management information of existing ISO images and it writes the
         session results to optical media or to filesystem objects.  Vice
         versa xorriso is able to copy file objects out of ISO 9660
         filesystems.
      '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/xorriso/;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
