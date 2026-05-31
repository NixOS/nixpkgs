{
  mkKdeDerivation,
  qtdeclarative,
  lmdb,
}:
mkKdeDerivation {
  pname = "baloo";

  # kde-systemd-start-condition is not part of baloo
  postPatch = ''
    substituteInPlace src/file/kde-baloo.service.in --replace-fail @KDE_INSTALL_FULL_BINDIR@/kde-systemd-start-condition /run/current-system/sw/bin/kde-systemd-start-condition
  '';

  extraBuildInputs = [
    qtdeclarative
    lmdb
  ];
}
