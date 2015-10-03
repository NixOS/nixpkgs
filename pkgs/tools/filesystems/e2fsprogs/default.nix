{ stdenv, fetchurl, pkgconfig, libuuid }:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.42.13";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1m72lk90b5i3h9qnmss6aygrzyn8x2avy3hyaq2fb0jglkrkz6ar";
  };

  outputs = [ "bin" "out" "man" ];
  outputDev = "bin"; # just for *.pc

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libuuid ];

  crossAttrs = {
    preConfigure = ''
      export CC=$crossConfig-gcc
    '';
  };

  configureFlags = [
    "--enable-elf-shlibs" "--enable-symlink-install" "--enable-relative-symlinks"
    # libuuid, libblkid, uuidd and fsck are in util-linux-ng (the "libuuid" dependency).
    "--disable-libuuid" "--disable-uuidd" "--disable-libblkid" "--disable-fsck"
  ];

  # hacky way to make it install *.pc
  postInstall = ''
    make install-libs
    rm "$out"/lib/*.a
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://e2fsprogs.sourceforge.net/;
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
