{
  lib,
  stdenvNoCC,
  fetchurl,
  apacheAnt,
  jdk,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "axis2";
  version = "1.8.2";

  src = fetchurl {
    url = "mirror://apache/axis/axis2/java/core/${version}/${pname}-${version}-bin.zip";
    hash = "sha256-oilPVFFpl3F61nVDxcYx/bc81FopS5fzoIdXzeP8brk=";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    apacheAnt
    jdk
  ];
  builder = ./builder.sh;

  meta = {
    description = "Web Services / SOAP / WSDL engine, the successor to the widely used Apache Axis SOAP stack";
    homepage = "https://axis.apache.org/axis2/java/core/";
    changelog = "https://axis.apache.org/axis2/java/core/release-notes/${version}.html";
    maintainers = [ lib.maintainers.anthonyroussel ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
  };
}
