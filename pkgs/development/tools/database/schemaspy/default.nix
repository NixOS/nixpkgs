{ lib, stdenv, fetchurl, jre, makeWrapper, graphviz }:

stdenv.mkDerivation rec {
  version = "6.1.0";
  pname = "schemaspy";

  src = fetchurl {
    url = "https://github.com/schemaspy/schemaspy/releases/download/v${version}/${pname}-${version}.jar";
    sha256 = "0lgz6b17hx9857fb2l03ggz8y3n8a37vrcsylif0gmkwj1v4qgl7";
  };

  dontUnpack = true;

  buildInputs = [
    jre
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  wrappedPath = lib.makeBinPath [
    graphviz
  ];

  installPhase = ''
    install -D ${src} "$out/share/java/${pname}-${version}.jar"

    makeWrapper ${jre}/bin/java $out/bin/schemaspy \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar" \
      --prefix PATH : "$wrappedPath"
  '';

  meta = with lib; {
    homepage = "http://schemaspy.org";
    description = "Document your database simply and easily";
    license = licenses.mit;
    maintainers = with maintainers; [ jraygauthier ];
  };
}

