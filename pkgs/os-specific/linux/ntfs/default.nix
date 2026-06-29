{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "linux-ntfs";
  version = "0-unstable-2026-05-20";

  src = fetchFromGitHub {
    owner = "namjaejeon";
    repo = "linux-ntfs";
    rev = "5893a4b30e4a821348ab158f594f2c3c9409694e";
    hash = "sha256-wAK9GX2au7bCw2pQB2cYJp1U9bOuS44bKKlLgBURD5c=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  strictDeps = true;
  __structuredAttrs = true;

  enableParallelBuilding = true;

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  makeFlags =
    kernelModuleMakeFlags
    ++ [
      "-C"
      "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "M=$(sourceRoot)"
    ]
    # override kernel config
    ++ lib.optionals (kernel.kernelAtLeast "5.15" && kernel.kernelOlder "6.9") [ "CONFIG_NTFS_FS=m" ];

  buildFlags = [ "modules" ];
  installFlags = [
    "INSTALL_MOD_PATH=${placeholder "out"}"
    # same as Makefile
    "INSTALL_MOD_DIR=kernel/fs/ntfs"
  ];
  installTargets = [ "modules_install" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "NTFS(NTFS PLUS) driver for Linux";
    homepage = "https://github.com/namjaejeon/linux-ntfs";
    # mainly GPL-2.0-plus, EXCEPT Kconfig, Makefile and uapi_ntfs.h which are GPL-2.0-only
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      ccicnce113424
    ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "6.1";
  };
}
