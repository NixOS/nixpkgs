{ stdenv
, fetchurl
, lib
, extra-cmake-modules
, kdoctools
, wrapQtAppsHook
, baloo
, karchive
, kconfig
, kcrash
, kfilemetadata
, kinit
, kirigami2
, knewstuff
, okular
, plasma-framework
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "peruse";
  # while technically a beta, the latest release is from 2016 and doesn't build without a lot of
  # patching
  version = "1.80";

  src = fetchurl {
    url = "mirror://kde/stable/peruse/peruse-${finalAttrs.version}.tar.xz";
    hash = "sha256-xnSVnKF20jbxVoFW41A22NZWVZUry/F7G+Ts5NK6M1E=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    baloo
    karchive
    kconfig
    kcrash
    kfilemetadata
    kinit
    kirigami2
    knewstuff
    okular
    plasma-framework
  ];

  # the build is otherwise crazy loud
  cmakeFlags = [ "-Wno-dev" ];

  pathsToLink = [ "/etc/xdg/peruse.knsrc" ];

  meta = with lib; {
    description = "Comic book reader";
    homepage = "https://peruse.kde.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "peruse";
    inherit (kirigami2.meta) platforms;
  };
})
