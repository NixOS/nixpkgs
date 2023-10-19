{ lib, stdenv, fetchurl, ant, jdk, hdf4, hdf5, makeDesktopItem, copyDesktopItems }:

stdenv.mkDerivation rec {
  pname = "hdfview";
  version = "3.3.1";

  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF5/releases/HDF-JAVA/${pname}-${version}/src/${pname}-${version}.tar.gz";
    sha256 = "sha256-WcGYceMOB8gCycJSW4KdApy2gIBgTnE/d0PxGZClUqg=";
  };

  patches = [
    # Hardcode isUbuntu=false to avoid calling hostname to detect os
    ./0001-Hardcode-isUbuntu-false-to-avoid-hostname-dependency.patch
    # Disable signing on macOS
    ./disable-mac-signing.patch
  ];

  nativeBuildInputs = [
    ant
    jdk
    copyDesktopItems
  ];

  HDFLIBS = (hdf4.override { javaSupport = true; }).out;
  HDF5LIBS = (hdf5.override { javaSupport = true; }).out;

  buildPhase =
    let
      arch = if stdenv.isx86_64 then "x86_64" else "aarch64";
    in
    ''
      runHook preBuild

      ant createJPackage -Dmachine.arch=${arch}

      runHook postBuild
    '';

  desktopItem = makeDesktopItem rec {
    name = "HDFView";
    desktopName = name;
    exec = name;
    icon = name;
    comment = meta.description;
    categories = [ "Science" "DataVisualization" ];
  };

  installPhase = ''
    runHook preInstall
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $out/bin $out/lib
    cp -a build/dist/HDFView/bin/HDFView $out/bin/
    cp -a build/dist/HDFView/lib/app $out/lib/
    cp -a build/dist/HDFView/lib/libapplauncher.so $out/lib/
    ln -s ${jdk}/lib/openjdk $out/lib/runtime

    mkdir -p $out/share/applications $out/share/icons/hicolor/32x32/apps
    cp src/HDFView.png $out/share/icons/hicolor/32x32/apps/
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -a build/dist/HDFView.app $out/Applications/
  '' + ''
    runHook postInstall
  '';

  meta = {
    description = "A visual tool for browsing and editing HDF4 and HDF5 files";
    license = lib.licenses.free; # BSD-like
    homepage = "https://portal.hdfgroup.org/display/HDFVIEW/HDFView";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ jiegec ];
  };
}
