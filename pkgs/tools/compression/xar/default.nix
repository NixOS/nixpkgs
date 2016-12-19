{ stdenv, fetchurl, libxml2, openssl, zlib, bzip2 }:

stdenv.mkDerivation rec {
  version = "1.5.2";
  name    = "xar-${version}";

  src = fetchurl {
    url    = "https://xar.googlecode.com/files/${name}.tar.gz";
    sha256 = "1rp3va6akzlh35yqrapfqnbxaxa0zi8wyr93swbapprwh215cpac";
  };

  buildInputs = [ libxml2 openssl zlib bzip2 ];

  meta = {
    homepage    = https://code.google.com/p/xar/;
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
