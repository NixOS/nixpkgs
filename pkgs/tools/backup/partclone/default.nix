{stdenv, fetchurl
, pkgconfig, libuuid
, e2fsprogs
}:
stdenv.mkDerivation {
  name = "partclone-stable";
  enableParallelBuilding = true;

  src = fetchurl {
    url = https://codeload.github.com/Thomas-Tsai/partclone/legacy.tar.gz/stable;
    sha256 = "0vvk6c26gf2wv5y0mxnz90bivgp84pi82qk5q5xkcz6nz3swals7";
    name = "Thomas-Tsai-partclone-stable-0-gab3bd53.tar.gz";
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
