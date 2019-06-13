{ mkDerivation, fetchurl, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook
, kconfig, kcrash, kinit, kpmcore
, eject, libatasmart , utillinux, makeWrapper, qtbase
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

  enableParallelBuilding = true;

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook makeWrapper ];

  # refer to kpmcore for the use of eject
  buildInputs = [ eject libatasmart utillinux ];
  propagatedBuildInputs = [ kconfig kcrash kinit kpmcore ];

  postInstall = ''
    wrapProgram "$out/bin/partitionmanager" --prefix QT_PLUGIN_PATH : "${kpmcore}/lib/qt-5.${lib.versions.minor qtbase.version}/plugins"
  '';

  meta = with lib; {
    description = "KDE Partition Manager";
    license = licenses.gpl2;
    homepage = https://www.kde.org/applications/system/kdepartitionmanager/;
    maintainers = with maintainers; [ peterhoeg ma27 ];
  };
}
