{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kconfig, kcrash, kinit
}:

let
  pname = "kronometer";
  version = "2.2.3";
in
mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "05hs8729a3aqjpwmn2xdf2sriacrll4sj4ax3lm4s1ravj09n9bm";
  };

  meta = with lib; {
    homepage = "https://kde.org/applications/utilities/kronometer/";
    description = "A stopwatch application";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [ kconfig kcrash kinit ];
}
