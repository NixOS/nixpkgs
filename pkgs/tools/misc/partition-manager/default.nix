{ mkDerivation, fetchurl, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook, wrapQtAppsHook
, kconfig, kcrash, kinit, kpmcore
, eject, libatasmart , util-linux, qtbase
}:

let
  pname = "partitionmanager";
in mkDerivation rec {
  name = "${pname}-${version}";
  version = "3.3.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0jhggb4xksb0k0mj752n6pz0xmccnbzlp984xydqbz3hkigra1si";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook wrapQtAppsHook ];

  # refer to kpmcore for the use of eject
  buildInputs = [ eject libatasmart util-linux ];
  propagatedBuildInputs = [ kconfig kcrash kinit kpmcore ];

  meta = with lib; {
    description = "KDE Partition Manager";
    license = licenses.gpl2;
    homepage = "https://www.kde.org/applications/system/kdepartitionmanager/";
    maintainers = with maintainers; [ peterhoeg ];
  };
}
