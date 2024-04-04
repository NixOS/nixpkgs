{ lib, stdenv, fetchurl, makeWrapper, jdk11, nixosTests }:

stdenv.mkDerivation rec {
  pname = "metabase";
  version = "0.49.1";

  src = fetchurl {
    url = "https://downloads.metabase.com/v${version}/metabase.jar";
    hash = "sha256-oyh25h59udfwuLqZJ4ngGYL+tup9GEWgegcTNb0PeHE=";
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
    mainProgram = "metabase";
  };
  passthru.tests = {
    inherit (nixosTests) metabase;
  };
}
