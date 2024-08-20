{
  lib,
  mkKdeDerivation,
  writeText,
  pkg-config,
  cryptsetup,
  lvm2,
  mdadm,
  smartmontools,
  systemdMinimal,
  util-linux,
  btrfs-progs,
  dosfstools,
  e2fsprogs,
  exfatprogs,
  f2fs-tools,
  fatresize,
  hfsprogs,
  jfsutils,
  nilfs-utils,
  ntfs3g,
  reiser4progs,
  reiserfsprogs,
  udftools,
  xfsprogs,
  zfs,
}: let
  # https://github.com/KDE/kpmcore/blob/06f15334ecfbe871730a90dbe2b694ba060ee998/src/util/externalcommand_whitelist.h
  runtimeDeps = [
    cryptsetup
    lvm2
    mdadm
    smartmontools
    systemdMinimal
    util-linux

    btrfs-progs
    dosfstools
    e2fsprogs
    exfatprogs
    f2fs-tools
    fatresize
    hfsprogs
    jfsutils
    nilfs-utils
    ntfs3g
    reiser4progs
    reiserfsprogs
    udftools
    xfsprogs
    zfs

    # FIXME: Missing command: hfsck hformat fsck.nilfs2 {fsck,mkfs,debugfs,tunefs}.ocfs2
    # FIXME: audit to see if these are all still required
  ];

  trustedprefixes = writeText "kpmcore-trustedprefixes" (lib.concatStringsSep "\n" (map lib.getBin runtimeDeps));
in
  mkKdeDerivation {
    pname = "kpmcore";

    postPatch = ''
      cp ${trustedprefixes} src/util/trustedprefixes
    '';

    preConfigure = ''
      substituteInPlace src/util/CMakeLists.txt \
        --replace \$\{POLKITQT-1_POLICY_FILES_INSTALL_DIR\} $out/share/polkit-1/actions
      substituteInPlace src/backend/corebackend.cpp \
        --replace /usr/share/polkit-1/actions/org.kde.kpmcore.externalcommand.policy $out/share/polkit-1/actions/org.kde.kpmcore.externalcommand.policy
    '';

    extraNativeBuildInputs = [pkg-config];
  }
