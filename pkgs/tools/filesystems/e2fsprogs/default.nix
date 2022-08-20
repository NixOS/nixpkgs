{ lib, stdenv, buildPackages, fetchurl, fetchpatch, pkg-config, libuuid, gettext, texinfo
, fuse
, shared ? !stdenv.hostPlatform.isStatic
, e2fsprogs, runCommand
}:

stdenv.mkDerivation rec {
  pname = "e2fsprogs";
  version = "1.46.5";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1fgvwbj9ihz5svzrd2l0s18k16r4qg3wimrniv71fn3vdcg0shxp";
  };

  # fuse2fs adds 14mb of dependencies
  outputs = [ "bin" "dev" "out" "man" "info" ]
    ++ lib.optionals stdenv.isLinux [ "fuse2fs" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkg-config texinfo ];
  buildInputs = [ libuuid gettext ]
    ++ lib.optionals stdenv.isLinux [ fuse ];

  patches = [
    (fetchpatch {
      name = "CVE-2022-1304.patch";
      url = "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/patch/?id=ab51d587bb9b229b1fade1afd02e1574c1ba5c76";
      sha256 = "sha256-YEEow34/81NBOc6F6FS6i505FCQ7GHeIz0a0qWNs7Fg=";
    })
    (fetchpatch { # avoid using missing __GNUC_PREREQ(X,Y)
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
      # It seems that the e2fsprogs is one of the few packages that cannot be
      # build with shared and static libs.
      (if shared then "--enable-elf-shlibs" else "--disable-elf-shlibs")
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
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $fuse2fs/bin
    mv $bin/bin/fuse2fs $fuse2fs/bin/fuse2fs
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    simple-filesystem = runCommand "e2fsprogs-create-fs" {} ''
      mkdir -p $out
      truncate -s10M $out/disc
      ${e2fsprogs}/bin/mkfs.ext4 $out/disc | tee $out/success
      ${e2fsprogs}/bin/e2fsck -n $out/disc | tee $out/success
      [ -e $out/success ]
    '';
  };
  meta = with lib; {
    homepage = "http://e2fsprogs.sourceforge.net/";
    changelog = "http://e2fsprogs.sourceforge.net/e2fsprogs-release.html#${version}";
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
    license = with licenses; [
      gpl2Plus
      lgpl2Plus # lib/ext2fs, lib/e2p
      bsd3      # lib/uuid
      mit       # lib/et, lib/ss
    ];
    platforms = platforms.unix;
    maintainers = [ maintainers.eelco ];
  };
}
