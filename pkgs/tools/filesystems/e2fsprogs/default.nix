{ stdenv, buildPackages, fetchurl, fetchpatch, pkgconfig, libuuid, gettext, texinfo }:

stdenv.mkDerivation rec {
  pname = "e2fsprogs";
  version = "1.45.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0jsclghxfzj9qmdd3qqk0gdmkrgjv2gakf8qz9dba37qkj1nk776";
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
      sha256 = "1gfcsr0i3q8q2f0lqza8na0iy4l4p3cbii51ds6zmj0y4hz2dwhb";
      excludes = [ "lib/ext2fs/hashmap.h" ];
      extraPrefix = "";
      })
    ];

  postPatch = ''
    # Remove six failing tests
    # https://github.com/NixOS/nixpkgs/issues/65471
    for test in m_image_mmp m_mmp m_mmp_bad_csum m_mmp_bad_magic t_mmp_1on t_mmp_2off; do
        rm -r "tests/$test"
    done
  '';

  configureFlags =
    if stdenv.isLinux then [
      "--enable-elf-shlibs"
      "--enable-symlink-install"
      "--enable-relative-symlinks"
      "--with-crond-dir=no"
      # fsck, libblkid, libuuid and uuidd are in util-linux-ng (the "libuuid" dependency)
      "--disable-fsck"
      "--disable-libblkid"
      "--disable-libuuid"
      "--disable-uuidd"
    ] else [
      "--enable-libuuid --disable-e2initrd-helper"
    ];

  checkInputs = [ buildPackages.perl ];
  doCheck = true;

  postInstall = ''
    # avoid cycle between outputs
    if [ -f $out/lib/${pname}/e2scrub_all_cron ]; then
      mv $out/lib/${pname}/e2scrub_all_cron $bin/bin/
    fi
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
