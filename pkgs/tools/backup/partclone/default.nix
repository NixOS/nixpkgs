{stdenv, fetchFromGitHub
, pkgconfig, libuuid
, e2fsprogs, automake, autoconf
}:
stdenv.mkDerivation {
  name = "partclone-stable";
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "Thomas-Tsai";
    repo = "partclone";
    rev = "stable";
    sha256 = "0q3brjmnldpr89nhbiajxg3gncz0nagc34n7q2723lpz7bn28w3z";
  };

  buildInputs = [e2fsprogs pkgconfig libuuid automake autoconf];

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
