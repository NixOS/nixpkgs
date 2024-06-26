{ lib, stdenv, buildPackages, fetchurl, fetchpatch, pkg-config, libuuid, gettext, texinfo
, withFuse ? stdenv.isLinux, fuse3
, shared ? !stdenv.hostPlatform.isStatic
, e2fsprogs, runCommand
}:

stdenv.mkDerivation rec {
  pname = "e2fsprogs";
  version = "1.47.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-mvzSAfOUKdLbJJKusT26XnXWzFBoK3MtyjVkO9XwkuM=";
  };

  # fuse2fs adds 14mb of dependencies
  outputs = [ "bin" "dev" "out" "man" "info" ]
    ++ lib.optionals withFuse [ "fuse2fs" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkg-config texinfo ];
  buildInputs = [ libuuid gettext ]
    ++ lib.optionals withFuse [ fuse3 ];

  patches = [
    # Avoid trouble with older systems like NixOS 23.05.
    # TODO: most likely drop this at some point, e.g. when 23.05 loses support.
    (fetchurl {
      name = "mke2fs-avoid-incompatible-features.patch";
      url = "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/plain/debian/patches/disable-metadata_csum_seed-and-orphan_file-by-default?h=debian/master&id=3fb3d18baba90e5d48d94f4c0b79b2d271b0c913";
      hash = "sha256-YD11K4s2bqv0rvzrxtaiodzLp3ztULlOlPUf1XcpxRY=";
    })
    (fetchurl {
      name = "SIZEOF_SIZE_T.patch";
      url = "https://lore.kernel.org/linux-ext4/20240527074121.2767083-1-hi@alyssa.is/raw";
      hash = "sha256-QdsvcvBi0mC/4YErqG0UKl94MH0OZpFVTGszNqBe/qw=";
    })
    (fetchurl {
      name = "unused-parameters.patch";
      url = "https://lore.kernel.org/linux-ext4/20240527091542.4121237-2-hi@alyssa.is/raw";
      hash = "sha256-pMoqm2eo5zYaTdU+Ppa4+posCVFb2A9S4uo5oApaaqc=";
    })
  ];

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

  nativeCheckInputs = [ buildPackages.perl ];
  doCheck = true;

  postInstall = ''
    # avoid cycle between outputs
    if [ -f $out/lib/${pname}/e2scrub_all_cron ]; then
      mv $out/lib/${pname}/e2scrub_all_cron $bin/bin/
    fi
  '' + lib.optionalString withFuse ''
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
    homepage = "https://e2fsprogs.sourceforge.net/";
    changelog = "https://e2fsprogs.sourceforge.net/e2fsprogs-release.html#${version}";
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
