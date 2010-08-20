{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "gzip-1.4";

  src = fetchurl {
    url = "mirror://gnu/gzip/${name}.tar.gz";
    sha256 = "1vhiyzls60fws48scw48wvwn8mpv1f4yhcsnafys239qvb9wyrni";
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
