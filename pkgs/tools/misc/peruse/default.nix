{ mkDerivation
, fetchFromGitHub
, lib
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, baloo
, karchive
, kconfig
, kcrash
, kfilemetadata
, kinit
, kirigami2
, knewstuff
, plasma-framework
}:

mkDerivation rec {
  pname = "peruse";
  version = "1.2.20200208";

  # The last formal release from 2016 uses kirigami1 which is deprecated
  src = fetchFromGitHub {
    owner = "KDE";
    repo = pname;
    rev = "4a1b3f954d2fe7e4919c0c5dbee1917776da582e";
    sha256 = "1s5yy240x4cvrk93acygnrp5m10xp7ln013gdfbm0r5xvd8xy19k";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wrapGAppsHook
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
    plasma-framework
  ];

  pathsToLink = [ "/etc/xdg/peruse.knsrc" ];

  meta = with lib; {
    description = "A comic book reader";
    homepage = "https://peruse.kde.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };

}
