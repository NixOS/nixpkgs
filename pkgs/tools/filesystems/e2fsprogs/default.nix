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
      url = "https://raw.githubusercontent.com/void-linux/void-packages/9583597eb3e6e6b33f61dbc615d511ce030bc443/srcpkgs/e2fsprogs/patches/fix-glibcism.patch";
      sha256 = "1fyml1iwrs412xn2w36ra28am3sq4klrrj60lnf7rysyw069nxk3";
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
    platforms = platforms.unix;
    maintainers = [ maintainers.eelco ];
  };
}
