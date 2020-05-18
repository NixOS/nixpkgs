{ stdenv, fetchFromGitHub, autoreconfHook
, pkgconfig, libuuid, e2fsprogs, nilfs-utils, ntfs3g
}:

stdenv.mkDerivation rec {
  pname = "partclone";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "Thomas-Tsai";
    repo = "partclone";
    rev = version;
    sha256 = "0bv15i0gxym4dv48rgaavh8p94waryn1l6viis6qh5zm9cd08skg";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    e2fsprogs libuuid stdenv.cc.libc nilfs-utils ntfs3g 
    (stdenv.lib.getOutput "static" stdenv.cc.libc)
  ];

  configureFlags = [
    "--enable-xfs"
    "--enable-extfs"
    "--enable-hfsp"
    "--enable-fat"
    "--enable-exfat"
    "--enable-ntfs"
    "--enable-btrfs"
    "--enable-minix"
    "--enable-f2fs"
    "--enable-nilfs2"
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
    homepage = "https://partclone.org";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
