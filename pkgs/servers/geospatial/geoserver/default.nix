{ lib
, fetchurl
, makeWrapper
, nixosTests
, stdenv

, jre
, unzip
}:

stdenv.mkDerivation rec {
  pname = "geoserver";
  version = "2.24.1";

  src = fetchurl {
    url = "mirror://sourceforge/geoserver/GeoServer/${version}/geoserver-${version}-bin.zip";
    sha256 = "sha256-3GdpM5BIH6+NME+/Zig0c7pYFWuWZywT6goD9JT6gZI=";
  };

  patches = [
    # set GEOSERVER_DATA_DIR to current working directory if not provided
    ./data-dir.patch
  ];

  sourceRoot = ".";
  nativeBuildInputs = [ unzip makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/geoserver
    cp -r . $out/share/geoserver
    rm -fr $out/share/geoserver/bin/*.bat

    makeWrapper $out/share/geoserver/bin/startup.sh $out/bin/geoserver-startup \
      --set JAVA_HOME "${jre}" \
      --set GEOSERVER_HOME "$out/share/geoserver"
    makeWrapper $out/share/geoserver/bin/shutdown.sh $out/bin/geoserver-shutdown \
      --set JAVA_HOME "${jre}" \
      --set GEOSERVER_HOME "$out/share/geoserver"
    runHook postInstall
  '';

  passthru = {
    tests.geoserver = nixosTests.geoserver;
  };

  meta = with lib; {
    description = "Open source server for sharing geospatial data";
    homepage = "https://geoserver.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2Plus;
    maintainers = teams.geospatial.members;
    platforms = platforms.all;
  };
}
