{ version, sha256Hash, maintainers }:

{ stdenv, fetchFromGitHub, fetchpatch
, fusePackages, utillinux, gettext
, autoconf, automake, libtool
, meson, ninja, pkgconfig
}:

let
  isFuse3 = stdenv.lib.hasPrefix "3" version;
in stdenv.mkDerivation rec {
  name = "fuse-${version}";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "libfuse";
    rev = name;
    sha256 = sha256Hash;
  };

  patches =
    stdenv.lib.optional
      (!isFuse3 && stdenv.isAarch64)
      (fetchpatch {
        url = "https://github.com/libfuse/libfuse/commit/914871b20a901e3e1e981c92bc42b1c93b7ab81b.patch";
        sha256 = "1w4j6f1awjrycycpvmlv0x5v9gprllh4dnbjxl4dyl2jgbkaw6pa";
      })
    ++ stdenv.lib.optional isFuse3 ./fuse3-install.patch;


  nativeBuildInputs = if isFuse3
    then [ meson ninja pkgconfig ]
    else [ autoconf automake libtool ];
  buildInputs = stdenv.lib.optional (!isFuse3) gettext;

  outputs = [ "out" ] ++ stdenv.lib.optional isFuse3 "common";

  mesonFlags = stdenv.lib.optional isFuse3 "-Dudevrulesdir=etc/udev/rules.d";

  preConfigure = ''
    export MOUNT_FUSE_PATH=$out/sbin
    export INIT_D_PATH=$TMPDIR/etc/init.d
    export UDEV_RULES_PATH=$out/etc/udev/rules.d

    # Ensure that FUSE calls the setuid wrapper, not
    # $out/bin/fusermount. It falls back to calling fusermount in
    # $PATH, so it should also work on non-NixOS systems.
    export NIX_CFLAGS_COMPILE="-DFUSERMOUNT_DIR=\"/run/wrappers/bin\""

    sed -e 's@/bin/@${utillinux}/bin/@g' -i lib/mount_util.c
    '' + (if isFuse3 then ''
      # The configure phase will delete these files (temporary workaround for
      # ./fuse3-install_man.patch)
      install -D -m444 doc/fusermount3.1 $out/share/man/man1/fusermount3.1
      install -D -m444 doc/mount.fuse.8 $out/share/man/man8/mount.fuse.8
    '' else ''
      sed -e 's@CONFIG_RPATH=/usr/share/gettext/config.rpath@CONFIG_RPATH=${gettext}/share/gettext/config.rpath@' -i makeconf.sh
      ./makeconf.sh
    '');

  postFixup = "cd $out\n" + (if isFuse3 then ''
    mv bin/mount.fuse3 bin/mount.fuse

    install -D -m555 bin/mount.fuse $common/bin/mount.fuse
    install -D -m444 etc/udev/rules.d/99-fuse.rules $common/etc/udev/rules.d/99-fuse.rules
    install -D -m444 share/man/man8/mount.fuse.8.gz $common/share/man/man8/mount.fuse.8.gz
  '' else ''
    cp ${fusePackages.fuse_3.common}/bin/mount.fuse bin/mount.fuse
    cp ${fusePackages.fuse_3.common}/etc/udev/rules.d/99-fuse.rules etc/udev/rules.d/99-fuse.rules
    cp ${fusePackages.fuse_3.common}/share/man/man8/mount.fuse.8.gz share/man/man8/mount.fuse.8.gz
  '');

  enableParallelBuilding = true;

  meta = {
    inherit (src.meta) homepage;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
    platforms = stdenv.lib.platforms.linux;
    inherit maintainers;
  };
}
