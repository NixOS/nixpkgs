{ lib, stdenv, fetchurl, unzip, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "geoserver";
<<<<<<< HEAD
  version = "2.23.2";

  src = fetchurl {
    url = "mirror://sourceforge/geoserver/GeoServer/${version}/geoserver-${version}-bin.zip";
    sha256 = "sha256-4zOtcUWeb/zubEY3wNCYBeStRSga2bm1BnBa+qcyeCw=";
=======
  version = "2.23.0";

  src = fetchurl {
    url = "mirror://sourceforge/geoserver/GeoServer/${version}/geoserver-${version}-bin.zip";
    sha256 = "sha256-qoRyU+dZrgYKa6tqe13nHJacOlNiSMuCECtfMFxu1Vg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
