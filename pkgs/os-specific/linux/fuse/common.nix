{ version, sha256Hash }:

{ stdenv, fetchFromGitHub, fetchpatch
, fusePackages, utillinux, gettext
, meson, ninja, pkgconfig
, autoreconfHook
, python3Packages, which
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

  preAutoreconf = "touch config.rpath";

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
    else [ autoreconfHook gettext ];

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
      install -D -m444 doc/mount.fuse3.8 $out/share/man/man8/mount.fuse3.8
    '' else ''
      sed -e 's@CONFIG_RPATH=/usr/share/gettext/config.rpath@CONFIG_RPATH=${gettext}/share/gettext/config.rpath@' -i makeconf.sh
      ./makeconf.sh
    '');

  checkInputs = [ which ] ++ (with python3Packages; [ python pytest ]);

  checkPhase = ''
    python3 -m pytest test/
  '';

  doCheck = false; # v2: no tests, v3: all tests get skipped in a sandbox

  postFixup = "cd $out\n" + (if isFuse3 then ''
    install -D -m444 etc/fuse.conf $common/etc/fuse.conf
    install -D -m444 etc/udev/rules.d/99-fuse3.rules $common/etc/udev/rules.d/99-fuse.rules
  '' else ''
    cp ${fusePackages.fuse_3.common}/etc/fuse.conf etc/fuse.conf
    cp ${fusePackages.fuse_3.common}/etc/udev/rules.d/99-fuse.rules etc/udev/rules.d/99-fuse.rules
  '');

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
    platforms = platforms.linux;
    license = with licenses; [ gpl2 lgpl21 ];
    maintainers = [ maintainers.primeos ];
  };
}
