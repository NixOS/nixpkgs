{ stdenv, buildPackages, fetchurl, pkgconfig, libuuid, gettext, texinfo }:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.44.0";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1l8z17zfzhi00f56xl6c4f2g3fi9m4ixlmwpmaihm9y9qz1giaq4";
  };

  outputs = [ "bin" "dev" "out" "man" "info" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkgconfig texinfo ];
  buildInputs = [ libuuid gettext ];

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
