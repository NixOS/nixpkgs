{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kconfig, kcrash, kinit
}:

let
  pname = "kronometer";
  version = "2.2.2";
in
mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "142f1kqygil6d4pvh6pallin355h2rq5s1hs6gd11plcin6rkg2j";
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
