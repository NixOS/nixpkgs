{ version, sha256Hash }:

{ lib, stdenv, fetchFromGitHub, fetchpatch
, fusePackages, util-linux, gettext, shadow
, meson, ninja, pkg-config
, autoreconfHook
, runtimeShell
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
    sha256 = sha256Hash;
  };

  preAutoreconf = "touch config.rpath";

  patches =
    lib.optional
      (!isFuse3 && stdenv.isAarch64)
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

  # The `common` output (`fuse-common` from top-level) is for `/etc` which shares
  # between fuse2 and fuse3. From the documentation, `fuse3`'s common files are preferred,
  # even for `fuse2`.
  # https://github.com/libfuse/libfuse/blob/d372d3f80b5437e652ea501d8a4a917f7001b9d7/ChangeLog.rst#libfuse-300-2016-12-08
  #
  # It contains,
  # - An init script `/etc/init.d/fuse3`.
  #   This is unused for systemd-managed system.
  #
  # - A udev rules `/etc/udev/rules.d/99-fuse3.rules` to configure `/dev/fuse`.
  #   This is included in systemd-udevd default rules since very early time, thus unneeded.
  #   https://github.com/systemd/systemd/blob/0cf2dcf15402c60498165dbd3f14536766c05051/rules.d/50-udev-default.rules.in#L94
  #
  # - An example commented `/etc/fuse.conf`.
  #   In NixOS, we control and generate it in `nixos/modules/programs/fuse.nix`.
  #   Also the example actually enables nothing.
  #
  # Thus we really not need this output currently.
  outputs = [ "bin" "out" "dev" "man" ] ++ lib.optional isFuse3 "common";

  mesonFlags = lib.optionals isFuse3 [
    "-Duseroot=false"
    "-Dudevrulesdir=/udev/rules.d"
  ];

  # Ensure that FUSE calls the setuid wrapper, not
  # $out/bin/fusermount. It falls back to calling fusermount in
  # $PATH, so it should also work on non-NixOS systems.
  NIX_CFLAGS_COMPILE = ''-DFUSERMOUNT_DIR="/run/wrappers/bin"'';

  preConfigure = ''
    substituteInPlace lib/mount_util.c \
      --replace "/bin/mount" "${lib.getBin util-linux}/bin/mount" \
      --replace "/bin/umount" "${lib.getBin util-linux}/bin/umount"
    substituteInPlace util/mount.fuse.c \
      --replace "/bin/sh" "${runtimeShell}"
  '' + lib.optionalString (!isFuse3) ''
    export MOUNT_FUSE_PATH=$bin/bin

    # Do not install these files for fuse2, see comment of `outputs`.
    export INIT_D_PATH=$TMPDIR/etc/init.d
    export UDEV_RULES_PATH=$TMPDIR/etc/udev/rules.d

    # This is for `setuid=`, and needs root permission anyway.
    # No need to use the SUID wrapper.
    substituteInPlace util/mount.fuse.c \
      --replace '"su"' '"${lib.getBin shadow.su}/bin/su"'
    substituteInPlace makeconf.sh \
      --replace 'CONFIG_RPATH=/usr/share/gettext/config.rpath' 'CONFIG_RPATH=${lib.getLib gettext}/share/gettext/config.rpath'
    ./makeconf.sh
  '';

  checkInputs = [ which ] ++ (with python3Packages; [ python pytest ]);

  checkPhase = ''
    python3 -m pytest test/
  '';

  postInstall = lib.optionalString isFuse3 ''
    mkdir $common
    mv $out/etc $common
  '';

  doCheck = false; # v2: no tests, v3: all tests get skipped in a sandbox

  # Don't pull in SUID `fusermount{,3}` binaries into development environment.
  propagatedBuildOutputs = [ "out" ];

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
    maintainers = with maintainers; [ primeos oxalica ];
    outputsToInstall = [ "bin" ];
  };
}
