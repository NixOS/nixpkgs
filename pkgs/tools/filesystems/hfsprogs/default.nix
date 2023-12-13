{ lib, stdenv, fetchurl, fetchFromGitHub, openssl, libbsd }:

let
  version = "332.25";

  apple_src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "diskdev_cmds";
    rev = "diskdev_cmds-${version}";
    hash = "sha256-cycPGPx2Gbjn4FKGKuQKJkh+dWGbJfy6C+LTz8rrs0A=";
    name = "diskdev_cmds-${version}";
  };
in

stdenv.mkDerivation rec {
  pname = "hfsprogs";
  inherit version;

  srcs = [
    (fetchurl {
      url = "http://ftp.de.debian.org/debian/pool/main/h/hfsprogs/hfsprogs_${version}-11.debian.tar.gz";
      sha256 = "62d9b8599c66ebffbc57ce5d776e20b41341130d9b27341d63bda08460ebde7c";
    })
    apple_src
  ];

  postPatch = ''
    sed -ie '/sys\/sysctl.h/d' newfs_hfs.tproj/makehfs.c
  '';

  sourceRoot = apple_src.name;
  patches = [ "../debian/patches/*.patch" ];

  buildInputs = [ openssl libbsd ];
  makefile = "Makefile.lnx";

  # Inspired by PKGBUILD of https://www.archlinux.org/packages/community/x86_64/hfsprogs/
  installPhase = ''
    # Create required package directories
    install -m 755 -d "$out/bin"
    install -m 755 -d "$out/share/hfsprogs"
    install -m 755 -d "$out/share/man/man8/"
    # Copy executables
    install -m 755 "newfs_hfs.tproj/newfs_hfs" "$out/bin/mkfs.hfsplus"
    install -m 755 "fsck_hfs.tproj/fsck_hfs" "$out/bin/fsck.hfsplus"
    # Copy shared data
    install -m 644 "newfs_hfs.tproj/hfsbootdata.img" "$out/share/hfsprogs/hfsbootdata"
    # Copy man pages
    install -m 644 "newfs_hfs.tproj/newfs_hfs.8" "$out/share/man/man8/mkfs.hfsplus.8"
    install -m 644 "fsck_hfs.tproj/fsck_hfs.8" "$out/share/man/man8/fsck.hfsplus.8"
  '';

  meta = {
    description = "HFS/HFS+ user space utils";
    license = lib.licenses.apsl20;
    platforms = lib.platforms.linux;
  };
}
