{ lib, stdenv, fetchurl, jre, makeWrapper, graphviz }:

stdenv.mkDerivation rec {
  version = "6.0.0-rc2";
  pname = "schemaspy";

  src = fetchurl {
    url = "https://github.com/schemaspy/schemaspy/releases/download/v${version}/${pname}-${version}.jar";
    sha256 = "0ph1l62hy163m2hgybhkccqbcj6brna1vdbr7536zc37lzjxq9rn";
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

