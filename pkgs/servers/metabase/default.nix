{ lib, stdenv, fetchurl, makeWrapper, jdk11, nixosTests }:

stdenv.mkDerivation rec {
  pname = "metabase";
  version = "0.44.2";

  src = fetchurl {
    url = "https://downloads.metabase.com/v${version}/metabase.jar";
    hash = "sha256-I0cShK9/29kIjLtPDGlyysypofFV9Ai4Dbqt4IwTSA8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    makeWrapper ${jdk11}/bin/java $out/bin/metabase --add-flags "-jar $src"
    runHook postInstall
  '';

  meta = with lib; {
    description = "The easy, open source way for everyone in your company to ask questions and learn from data";
    homepage    = "https://metabase.com";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license     = licenses.agpl3Only;
    platforms   = platforms.all;
    maintainers = with maintainers; [ schneefux thoughtpolice mmahut ];
  };
  passthru.tests = {
    inherit (nixosTests) metabase;
  };
}
