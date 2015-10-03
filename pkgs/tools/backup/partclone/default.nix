{stdenv, fetchurl
, pkgconfig, libuuid
, e2fsprogs
}:
stdenv.mkDerivation {
  name = "partclone-stable";
  enableParallelBuilding = true;

  src = fetchurl {
    url = https://codeload.github.com/Thomas-Tsai/partclone/legacy.tar.gz/stable;
    sha256 = "12bnhljc4n4951p5c05gc7z5qwdsjpx867ad1npmgsm8d9w941sn";
    name = "Thomas-Tsai-partclone-stable-20150722.tar.gz";
  };

  buildInputs = [e2fsprogs pkgconfig libuuid];

  installPhase = ''make INSTPREFIX=$out install'';

  meta = {
    description = "Utilities to save and restore used blocks on a partition";
    longDescription = ''
      Partclone provides utilities to save and restore used blocks on a
      partition and is designed for higher compatibility of the file system by
      using existing libraries, e.g. e2fslibs is used to read and write the
      ext2 partition.
    '';
    homepage = http://partclone.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
