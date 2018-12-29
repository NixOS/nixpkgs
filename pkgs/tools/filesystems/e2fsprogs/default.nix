{ stdenv, buildPackages, fetchurl, fetchpatch, pkgconfig, libuuid, gettext, texinfo, perl }:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.44.5";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1k6iwv2bz2a8mcd1gg9kb5jpry7pil5v2h2f9apxax7g4yp1y89f";
  };

  outputs = [ "bin" "dev" "out" "man" "info" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkgconfig texinfo ];
  buildInputs = [ libuuid gettext ];

  # Only use glibc's __GNUC_PREREQ(X,Y) (checks if compiler is gcc version >= X.Y) when using glibc
  patches = if stdenv.hostPlatform.libc == "glibc" then null
    else [
      (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/1f3b51493031cc0309009804475e3db572fc89ad/srcpkgs/e2fsprogs/patches/fix-glibcism.patch";
      sha256 = "1q7y8nhsfwl9r1q7nhrlikazxxj97p93kgz5wh7723cshlji2vaa";
      extraPrefix = "";
      })
    ];

  configureFlags =
    if stdenv.isLinux then [
      "--enable-elf-shlibs" "--enable-symlink-install" "--enable-relative-symlinks"
      # libuuid, libblkid, uuidd and fsck are in util-linux-ng (the "libuuid" dependency).
      "--disable-libuuid" "--disable-uuidd" "--disable-libblkid" "--disable-fsck"
    ] else [
      "--enable-libuuid --disable-e2initrd-helper"
    ];

  checkInputs = [ perl ];
  doCheck = false; # fails

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
