{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenvNoCC.mkDerivation rec {
  pname = "panoply";
  version = "5.5.2";

  src = fetchurl {
    url = "https://www.giss.nasa.gov/tools/panoply/download/PanoplyJ-${version}.tgz";
    hash = "sha256-ff7O3pW8/2CDXrd6CU+ygFeyNoGNCeTHIH7cdm+k8TE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    jarbase=$out/share/panoply
    mkdir -p $out/bin $jarbase/jars

    sed -i "s:^SCRIPTDIR.*:SCRIPTDIR=$jarbase:" panoply.sh

    cp panoply.sh $out/bin/panoply
    cp -r jars $jarbase

    wrapProgram "$out/bin/panoply" --prefix PATH : "${jre}/bin"

    runHook postInstall
  '';

  meta = with lib; {
    description = "netCDF, HDF and GRIB Data Viewer";
    homepage = "https://www.giss.nasa.gov/tools/panoply";
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
    license = licenses.unfree; # Package does not state a license
    mainProgram = "panoply";
  };
}
