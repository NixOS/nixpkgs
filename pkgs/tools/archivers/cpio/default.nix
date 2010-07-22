{stdenv, fetchurl}:

stdenv.mkDerivation ({
  name = "cpio-2.11";

  src = fetchurl {
    url = mirror://gnu/cpio/cpio-2.11.tar.bz2;
    sha256 = "1gavgpzqwgkpagjxw72xgxz52y1ifgz0ckqh8g7cckz7jvyhp0mv";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/cpio/;
    description = "GNU cpio, a program to create or extract from cpio archives";

    longDescription =
      '' GNU cpio copies files into or out of a cpio or tar archive.  The
         archive can be another file on the disk, a magnetic tape, or a pipe.

         GNU cpio supports the following archive formats: binary, old ASCII,
         new ASCII, crc, HPUX binary, HPUX old ASCII, old tar, and POSIX.1
         tar.  The tar format is provided for compatability with the tar
         program.  By default, cpio creates binary format archives, for
         compatibility with older cpio programs.  When extracting from
         archives, cpio automatically recognizes which kind of archive it is
         reading and can read archives created on machines with a different
         byte-order.
      '';

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}

//

(if stdenv.isLinux
 then {}
 else { patches = [ ./darwin-fix.patch ]; }))
