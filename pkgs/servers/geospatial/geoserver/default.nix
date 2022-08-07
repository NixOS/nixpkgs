{ lib, stdenv, fetchurl, unzip, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "geoserver";
  version = "2.21.1";

  src = fetchurl {
    url = "mirror://sourceforge/geoserver/GeoServer/${version}/geoserver-${version}-bin.zip";
    sha256 = "sha256-Ln7vHU/J80edOJbL3lAezXrk+jJQ2mGWY9+61GyiLXk=";
  };

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

  meta = with lib; {
    description = "Open source server for sharing geospatial data";
    homepage = "https://geoserver.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
}
