{ fetchurl, lib, stdenv, libcdio, zlib, bzip2, readline, acl, attr, libiconv }:

stdenv.mkDerivation rec {
  pname = "xorriso";
  version = "1.5.6";

  src = fetchurl {
    url = "mirror://gnu/xorriso/xorriso-${version}.tar.gz";
    sha256 = "sha256-1La2a9BMScazWO5mR12AbW9tdIboARBqR9Mx3x8vj+s=";
  };

  doCheck = true;

  buildInputs = [ libcdio zlib bzip2 readline libiconv ]
    ++ lib.optionals stdenv.isLinux [ acl attr ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-include unistd.h";

  meta = with lib; {
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

    homepage = "https://www.gnu.org/software/xorriso/";

    maintainers = [ maintainers.vrthra ];
    platforms = platforms.unix;
  };
}
