{ fetchurl, stdenv, libcdio, zlib, bzip2, readline, acl, attr, libiconv }:

stdenv.mkDerivation rec {
  name = "xorriso-1.5.0";

  src = fetchurl {
    url = "mirror://gnu/xorriso/${name}.tar.gz";
    sha256 = "0aq6lvlwlkxz56l5sbvgycr6j5c82ch2bv6zrnc2345ibfpafgx9";
  };

  doCheck = true;

  buildInputs = [ libcdio zlib bzip2 readline libiconv ]
    ++ stdenv.lib.optionals stdenv.isLinux [ acl attr ];

  meta = with stdenv.lib; {
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

    license = licenses.gpl3Plus;

    homepage = https://www.gnu.org/software/xorriso/;

    maintainers = [ maintainers.vrthra ];
    platforms = platforms.unix;
  };
}
