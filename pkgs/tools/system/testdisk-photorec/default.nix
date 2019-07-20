{ stdenv
, fetchurl
, ncurses
, libuuid
, libjpeg
, zlib
, ntfs3g
, e2fsprogs
}:

stdenv.mkDerivation rec {
  name = "testdisk-photorec-${version}";
  version = "7.0";
  src = fetchurl {
    url = "https://www.cgsecurity.org/testdisk-${version}.tar.bz2";
    sha256 = "0ba4wfz2qrf60vwvb1qsq9l6j0pgg81qgf7fh22siaz649mkpfq0";
  };
  buildInputs = [
    ncurses
    libuuid
    # optional:
    libjpeg
    zlib
    ntfs3g
    e2fsprogs
    #libewf # makes it fail to build
    #qt4 # for qphotorec, which does not build in 7.0
  ];
  meta = with stdenv.lib; {
    homepage = https://www.cgsecurity.org/wiki/Main_Page;
    downloadPage = https://www.cgsecurity.org/wiki/TestDisk_Download;
    description = "Data recovery utilities";
    longDescription = ''
      TestDisk is a powerful free data recovery software. It was primarily
      designed to help recover lost partitions and/or make non-booting disks
      bootable again when these symptoms are caused by faulty software: certain
      types of viruses or human error (such as accidentally deleting a
      Partition Table).

      PhotoRec is a file data recovery software designed to recover lost files
      including video, documents and archives from hard disks, CD-ROMs, and
      lost pictures (thus the Photo Recovery name) from digital camera memory.
      PhotoRec ignores the file system and goes after the underlying data, so
      it will still work even if your media's file system has been severely
      damaged or reformatted.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
  };
}

