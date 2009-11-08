{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "gzip-1.3.13";

  src = fetchurl {
    url = "mirror://gnu/gzip/${name}.tar.gz";
    sha256 = "18vwa7x0b1sql9bs2d15n94fx3him1m6xpnwsfz52djjbjgzy1hx";
  };

  patches = [ ./getopt.patch ];

  doCheck = true;

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
