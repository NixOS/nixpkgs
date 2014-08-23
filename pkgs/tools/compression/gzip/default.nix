{ stdenv, fetchurl, less }:

stdenv.mkDerivation rec {
  name = "gzip-1.6";

  src = fetchurl {
    url = "mirror://gnu/gzip/${name}.tar.xz";
    sha256 = "0ivqnbhiwd12q8hp3qw6rpsrpw2jg5y2mymk8cn22lsx90dfvprp";
  };

  enableParallelBuilding = true;

  # In stdenv-linux, prevent a dependency on bootstrap-tools.
  makeFlags = "SHELL=/bin/sh GREP=grep";

  meta = {
    homepage = http://www.gnu.org/software/gzip/;
    description = "Gzip, the GNU zip compression program";

    longDescription =
      ''gzip (GNU zip) is a popular data compression program written by
        Jean-loup Gailly for the GNU project.  Mark Adler wrote the
        decompression part.

        We developed this program as a replacement for compress because of
        the Unisys and IBM patents covering the LZW algorithm used by
        compress.  These patents made it impossible for us to use compress,
        and we needed a replacement.  The superior compression ratio of gzip
        is just a bonus.
      '';

    license = stdenv.lib.licenses.gpl3Plus;
  };
}
