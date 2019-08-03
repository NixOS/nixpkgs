{
  mkDerivation, fetchFromGitHub, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  baloo, karchive, kconfig, kcrash, kfilemetadata, kinit, kirigami2, knewstuff, plasma-framework
}:

let
  pname = "peruse";
  version = "1.2.20180816";

in mkDerivation rec {
  name = "${pname}-${version}";

  # The last formal release from 2016 uses kirigami1 which is deprecated
  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = pname;
    rev    = "f50027c6c9c680c4e2ce1dba4ec43364e661e7a3";
    sha256 = "1217fa6w9ryh499agcc67mnp8k9dah4r0sw74qzsbk4p154jbgch";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ baloo karchive kconfig kcrash kfilemetadata kinit kirigami2 knewstuff plasma-framework ];

  pathsToLink = [ "/etc/xdg/peruse.knsrc"];

  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };

}
