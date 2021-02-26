{ lib, stdenv, fetchurl, ant, jdk, nettools, hdf4, hdf5, makeDesktopItem, copyDesktopItems }:

stdenv.mkDerivation rec {
  pname = "hdfview";
  version = "3.1.2";

  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF5/releases/HDF-JAVA/${pname}-${version}/src/${pname}-${version}.tar.gz";
    sha256 = "0kyw9i3f817z71l0ak7shl0wqxasz9h5fl05mklyapa7cj27637c";
  };

  nativeBuildInputs = [
    ant jdk
    nettools  # "hostname" required
    copyDesktopItems
  ];

  HDFLIBS = (hdf4.override { javaSupport = true; }).out;
  HDF5LIBS = (hdf5.override { javaSupport = true; }).out;

  buildPhase = ''
    runHook preBuild

    ant createJPackage

    runHook postBuild
  '';

  desktopItem = makeDesktopItem rec {
    name = "HDFView";
    desktopName = name;
    exec = name;
    icon = name;
    comment = meta.description;
    categories = "Science;DataVisualization;";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib
    cp -a build/dist/HDFView/bin/HDFView $out/bin/
    cp -a build/dist/HDFView/lib/app $out/lib/
    ln -s ${jdk}/lib/openjdk $out/lib/runtime

    mkdir -p $out/share/applications $out/share/icons/hicolor/32x32/apps
    cp src/HDFView.png $out/share/icons/hicolor/32x32/apps/

    runHook postInstall
  '';

  meta = {
    description = "A visual tool for browsing and editing HDF4 and HDF5 files";
    license = lib.licenses.free; # BSD-like
    homepage = "https://portal.hdfgroup.org/display/HDFVIEW/HDFView";
    platforms = lib.platforms.linux;
  };
}
