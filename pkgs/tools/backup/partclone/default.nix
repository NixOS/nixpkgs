{ lib, stdenv, fetchFromGitHub, autoreconfHook
, pkg-config, libuuid, e2fsprogs, nilfs-utils, ntfs3g, openssl
}:

stdenv.mkDerivation rec {
  pname = "partclone";
<<<<<<< HEAD
  version = "0.3.25";
=======
  version = "0.3.23";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Thomas-Tsai";
    repo = "partclone";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-DLO0mKQ7Ab+4hwRANnipkaCbS7qldGnfTotAYDy//XU=";
=======
    sha256 = "sha256-na9k26+GDdASZ37n0QtFuRDMtq338QOlXTf0X4raOJI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [
    e2fsprogs libuuid stdenv.cc.libc nilfs-utils ntfs3g openssl
    (lib.getOutput "static" stdenv.cc.libc)
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

  meta = with lib; {
    description = "Utilities to save and restore used blocks on a partition";
    longDescription = ''
      Partclone provides utilities to save and restore used blocks on a
      partition and is designed for higher compatibility of the file system by
      using existing libraries, e.g. e2fslibs is used to read and write the
      ext2 partition.
    '';
    homepage = "https://partclone.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
