{ stdenv, fetchurl, libxml2, openssl, zlib, bzip2, musl-fts }:

stdenv.mkDerivation rec {
  version = "1.6.1";
  name    = "xar-${version}";

  src = fetchurl {
    url    = "https://github.com/downloads/mackyle/xar/${name}.tar.gz";
    sha256 = "0ghmsbs6xwg1092v7pjcibmk5wkyifwxw6ygp08gfz25d2chhipf";
  };

  buildInputs = [ libxml2 openssl zlib bzip2 ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl musl-fts;

  meta = {
    homepage    = https://mackyle.github.io/xar/;
    description = "Extensible Archiver";

    longDescription =
      '' The XAR project aims to provide an easily extensible archive format.
         Important design decisions include an easily extensible XML table of
         contents for random access to archived files, storing the toc at the
         beginning of the archive to allow for efficient handling of streamed
         archives, the ability to handle files of arbitrarily large sizes, the
         ability to choose independent encodings for individual files in the
         archive, the ability to store checksums for individual files in both
         compressed and uncompressed form, and the ability to query the table
         of content's rich meta-data.
      '';

    license     = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ copumpkin ];
    platforms   = stdenv.lib.platforms.all;
  };
}
