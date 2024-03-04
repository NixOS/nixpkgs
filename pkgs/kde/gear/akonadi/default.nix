{
  lib,
  mkKdeDerivation,
  qttools,
  accounts-qt,
  kaccounts-integration,
  shared-mime-info,
  xz,
  mariadb,
}:
mkKdeDerivation {
  pname = "akonadi";

  patches = [
    # Always regenerate MySQL config, as the store paths don't have accurate timestamps
    ./ignore-mysql-config-timestamp.patch
  ];

  extraCmakeFlags = [
    "-DMYSQLD_SCRIPTS_PATH=${lib.getBin mariadb}/bin"
  ];

  extraNativeBuildInputs = [qttools shared-mime-info];
  extraBuildInputs = [kaccounts-integration accounts-qt xz mariadb];
}
