{ stdenv, fetchurl, pkgconfig, libuuid, gettext }:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.44.1";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1rn1nvp8kcvjmbh2bxrjfbrz7zz519d52rrxqvc50l0hzs6hda55";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  nativeBuildInputs = [ pkgconfig ];
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
