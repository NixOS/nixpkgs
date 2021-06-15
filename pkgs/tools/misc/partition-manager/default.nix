{ mkDerivation, fetchurl, lib, makeWrapper
, extra-cmake-modules, kdoctools, wrapGAppsHook, wrapQtAppsHook
, kconfig, kcrash, kinit, kpmcore
, cryptsetup, lvm2, mdadm, smartmontools, systemdMinimal, util-linux
, btrfs-progs, dosfstools, e2fsprogs, exfat, f2fs-tools, fatresize, hfsprogs
, jfsutils, nilfs-utils, ntfs3g, reiser4progs, reiserfsprogs, udftools, xfsprogs, zfs
}:

let
  # External programs are resolved by `partition-manager` and then
  # invoked by `kpmcore_externalcommand` from `kpmcore` as root.
  # So these packages should be in PATH of `partition-manager`.
  # https://github.com/KDE/kpmcore/blob/06f15334ecfbe871730a90dbe2b694ba060ee998/src/util/externalcommand_whitelist.h
  runtimeDeps = lib.makeBinPath [
    cryptsetup
    lvm2
    mdadm
    smartmontools
    systemdMinimal
    util-linux

    btrfs-progs
    dosfstools
    e2fsprogs
    exfat
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

    # FIXME: Missing command: tune.exfat hfsck hformat fsck.nilfs2 {fsck,mkfs,debugfs,tunefs}.ocfs2
  ];

in mkDerivation rec {
  pname = "partitionmanager";
  # NOTE: When changing this version, also change the version of `kpmcore`.
  version = "4.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-${version}.tar.xz";
    hash = "sha256-6Qlt1c47Eek6TkWWBzTyBZYJ1jfhtwsC9X5q5h6IhPg=";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook wrapQtAppsHook makeWrapper ];

  propagatedBuildInputs = [ kconfig kcrash kinit kpmcore ];

  postFixup = ''
    wrapProgram $out/bin/partitionmanager \
      --prefix PATH : "${runtimeDeps}"
  '';

  meta = with lib; {
    description = "KDE Partition Manager";
    license = with licenses; [ cc-by-40 cc0 gpl3Plus lgpl3Plus mit ];
    homepage = "https://www.kde.org/applications/system/kdepartitionmanager/";
    maintainers = with maintainers; [ peterhoeg oxalica ];
  };
}
