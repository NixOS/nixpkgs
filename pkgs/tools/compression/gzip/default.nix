{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gzip-1.5";

  src = fetchurl {
    url = "mirror://gnu/gzip/${name}.tar.xz";
    sha256 = "0wx1nqk709kx75cwp2axachnbxryp4gyl06qxn5nl95184w0mhls";
  };

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

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
