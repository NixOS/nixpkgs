{ version, hash }:

{ lib, stdenv, fetchFromGitHub, fetchpatch
, fusePackages, util-linux, gettext, shadow
, meson, ninja, pkg-config
, autoreconfHook
, python3Packages, which
}:

let
  isFuse3 = lib.hasPrefix "3" version;
in stdenv.mkDerivation rec {
  pname = "fuse";
  inherit version;

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "libfuse";
    rev = "${pname}-${version}";
    inherit hash;
  };

  preAutoreconf = "touch config.rpath";

  patches =
    lib.optional
      (!isFuse3 && (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isLoongArch64))
      (fetchpatch {
        url = "https://github.com/libfuse/libfuse/commit/914871b20a901e3e1e981c92bc42b1c93b7ab81b.patch";
        sha256 = "1w4j6f1awjrycycpvmlv0x5v9gprllh4dnbjxl4dyl2jgbkaw6pa";
      })
    ++ (if isFuse3
      then [ ./fuse3-install.patch ./fuse3-Do-not-set-FUSERMOUNT_DIR.patch ]
      else [
        ./fuse2-Do-not-set-FUSERMOUNT_DIR.patch
        (fetchpatch {
          url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-fs/fuse/files/fuse-2.9.9-closefrom-glibc-2-34.patch?id=8a970396fca7aca2d5a761b8e7a8242f1eef14c9";
          sha256 = "sha256-ELYBW/wxRcSMssv7ejCObrpsJHtOPJcGq33B9yHQII4=";
        })
      ]);

  nativeBuildInputs = if isFuse3
    then [ meson ninja pkg-config ]
    else [ autoreconfHook gettext ];

  outputs = [ "out" ] ++ lib.optional isFuse3 "common";

  mesonFlags = lib.optionals isFuse3 [
    "-Dudevrulesdir=/udev/rules.d"
    "-Duseroot=false"
    "-Dinitscriptdir="
  ];

  preConfigure = ''
    export MOUNT_FUSE_PATH=$out/sbin
    export INIT_D_PATH=$TMPDIR/etc/init.d
    export UDEV_RULES_PATH=$out/etc/udev/rules.d

    # Ensure that FUSE calls the setuid wrapper, not
    # $out/bin/fusermount. It falls back to calling fusermount in
    # $PATH, so it should also work on non-NixOS systems.
    export NIX_CFLAGS_COMPILE="-DFUSERMOUNT_DIR=\"/run/wrappers/bin\""

    substituteInPlace lib/mount_util.c --replace "/bin/" "${util-linux}/bin/"
    '' + (if isFuse3 then ''
      # The configure phase will delete these files (temporary workaround for
      # ./fuse3-install_man.patch)
      install -D -m444 doc/fusermount3.1 $out/share/man/man1/fusermount3.1
      install -D -m444 doc/mount.fuse3.8 $out/share/man/man8/mount.fuse3.8
    '' else ''
      substituteInPlace util/mount.fuse.c --replace '"su"' '"${shadow.su}/bin/su"'
      sed -e 's@CONFIG_RPATH=/usr/share/gettext/config.rpath@CONFIG_RPATH=${gettext}/share/gettext/config.rpath@' -i makeconf.sh
      ./makeconf.sh
    '');

  nativeCheckInputs = [ which ] ++ (with python3Packages; [ python pytest ]);

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

  meta = with lib; {
    description = "Library that allows filesystems to be implemented in user space";
    longDescription = ''
      FUSE (Filesystem in Userspace) is an interface for userspace programs to
      export a filesystem to the Linux kernel. The FUSE project consists of two
      components: The fuse kernel module (maintained in the regular kernel
      repositories) and the libfuse userspace library (this package). libfuse
      provides the reference implementation for communicating with the FUSE
      kernel module.
    '';
    homepage = "https://github.com/libfuse/libfuse";
    changelog = "https://github.com/libfuse/libfuse/releases/tag/fuse-${version}";
    platforms = platforms.linux;
    license = with licenses; [ gpl2Only lgpl21Only ];
    maintainers = [ maintainers.primeos ];
  };
}
