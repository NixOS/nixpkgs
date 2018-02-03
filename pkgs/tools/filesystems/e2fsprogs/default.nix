{ stdenv, fetchurl, pkgconfig, libuuid, gettext, texinfo }:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.43.8";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1pn33rap3lcjm3gx07pmgyhx4j634gja63phmi4g5dq8yj0z8ciz";
  };

  outputs = [ "bin" "dev" "out" "man" "info" ];

  nativeBuildInputs = [ pkgconfig texinfo ];
  buildInputs = [ libuuid ] ++ stdenv.lib.optional (!stdenv.isLinux) gettext;

  crossAttrs = {
    preConfigure = ''
      export CC=$crossConfig-gcc
    '';
  };

  configureFlags =
    if stdenv.isLinux then [
      "--enable-elf-shlibs" "--enable-symlink-install" "--enable-relative-symlinks"
      # libuuid, libblkid, uuidd and fsck are in util-linux-ng (the "libuuid" dependency).
      "--disable-libuuid" "--disable-uuidd" "--disable-libblkid" "--disable-fsck"
    ] else [
      "--enable-libuuid --disable-e2initrd-helper"
    ]
  ;

  # hacky way to make it install *.pc
  postInstall = ''
    make install-libs
    rm "$out"/lib/*.a
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://e2fsprogs.sourceforge.net/;
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}
