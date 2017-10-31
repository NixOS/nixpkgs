{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kconfig, kcrash, kinit
}:

let
  pname = "kronometer";
  version = "2.1.3";
in
mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "1z06gvaacm3d3a9smlmgg2vf0jdab5kqxx24r6v7iprqzgdpsn4i";
  };

  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [ kconfig kcrash kinit ];
}
