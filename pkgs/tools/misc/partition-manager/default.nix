{ mkDerivation, fetchurl, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook, wrapQtAppsHook
, kconfig, kcrash, kinit, kpmcore
, eject, libatasmart , util-linux, qtbase
}:

let
  pname = "partitionmanager";
in mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "e9096dd5ce3b11e93a4e45960734f2059609d637e1b70b02f57e6ae61e8884f8";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook wrapQtAppsHook ];

  cmakeFlags = [
    "-DKPMCORE_INCLUDE_DIR=${lib.getDev kpmcore}/include/kpmcore"
  ];

  # refer to kpmcore for the use of eject
  buildInputs = [ eject libatasmart util-linux kpmcore ];
  propagatedBuildInputs = [ kconfig kcrash kinit kpmcore ];

  meta = with lib; {
    description = "KDE Partition Manager";
    license = licenses.gpl2;
    homepage = "https://www.kde.org/applications/system/kdepartitionmanager/";
    maintainers = with maintainers; [ peterhoeg ];
  };
}
