{
  mkDerivation, fetchFromGitHub, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  baloo, karchive, kconfig, kcrash, kfilemetadata, kinit, kirigami2, knewstuff, plasma-framework
}:

let
  pname = "peruse";
  version = "1.2.20180219";

in mkDerivation rec {
  name = "${pname}-${version}";

  # The last formal release from 2016 uses kirigami1 which is deprecated
  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = pname;
    rev    = "4125d3149c45d196600258686610de701130113d";
    sha256 = "1x8in7z17gzgiibshw7xfs6m6bhr3n5fys3nlpab77nm0dl3f4r5";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ baloo karchive kconfig kcrash kfilemetadata kinit kirigami2 knewstuff plasma-framework ];

  pathsToLink = [ "/etc/xdg/peruse.knsrc"];

  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };

}
