{ mkDerivation
, stdenv
, fetchurl
, ncurses
, libuuid
, pkgconfig
, libjpeg
, zlib
, libewf
, enableNtfs ? !stdenv.isDarwin, ntfs3g ? null
, enableExtFs ? !stdenv.isDarwin, e2fsprogs ? null
, enableQt ? false, qtbase ? null, qttools ? null, qwt ? null
}:

assert enableNtfs -> ntfs3g != null;
assert enableExtFs -> e2fsprogs != null;
assert enableQt -> qtbase != null;
assert enableQt -> qttools != null;
assert enableQt -> qwt != null;

(if enableQt then mkDerivation else stdenv.mkDerivation) rec {
  pname = "testdisk";
  version = "7.1";
  src = fetchurl {
    url = "https://www.cgsecurity.org/testdisk-${version}.tar.bz2";
    sha256 = "1zlh44w67py416hkvw6nrfmjickc2d43v51vcli5p374d5sw84ql";
  };

  enableParallelBuilding = true;

  buildInputs = [
    ncurses
    libuuid
    libjpeg
    zlib
    libewf
  ]
  ++ stdenv.lib.optional enableNtfs ntfs3g
  ++ stdenv.lib.optional enableExtFs e2fsprogs
  ++ stdenv.lib.optionals enableQt [ qtbase qttools qwt ];

  nativeBuildInputs = [ pkgconfig ];

  NIX_CFLAGS_COMPILE="-Wno-unused";

  meta = with stdenv.lib; {
    homepage = https://www.cgsecurity.org/wiki/Main_Page;
    downloadPage = https://www.cgsecurity.org/wiki/TestDisk_Download;
    description = "Testdisk / Photorec - Data recovery utilities";
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
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = with maintainers; [ fgaz eelco ];
  };
}
