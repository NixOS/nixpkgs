{
  lib,
  stdenv,
  fetchgit,
  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,
  kio,
  fuse3,
}:

stdenv.mkDerivation rec {
  pname = "kio-fuse";
  version = "5.1.0";

  src = fetchgit {
    url = "https://invent.kde.org/system/kio-fuse.git";
    hash = "sha256-xVeDNkSeHCk86L07lPVokSgHNkye2tnLoCkdw4g2Jv0=";
    rev = "v${version}";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kio
    fuse3
  ];

  meta = {
    description = "FUSE Interface for KIO";
    homepage = "https://invent.kde.org/system/kio-fuse";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _1000teslas ];
  };
}
