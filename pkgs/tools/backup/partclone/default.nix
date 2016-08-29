{ stdenv, fetchFromGitHub, autoreconfHook
, pkgconfig, libuuid, e2fsprogs
}:

stdenv.mkDerivation rec {
  name = "partclone-${version}";
  version = "0.2.89";

  src = fetchFromGitHub {
    owner = "Thomas-Tsai";
    repo = "partclone";
    rev = version;
    sha256 = "0gw47pchqshhm00yf34qgxh6bh2jfryv0sm7ghwn77bv5gzwr481";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    e2fsprogs libuuid stdenv.cc.libc
    (stdenv.lib.getOutput "static" stdenv.cc.libc)
  ];

  enableParallelBuilding = true;

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
