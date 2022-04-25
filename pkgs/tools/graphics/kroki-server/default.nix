{ lib
, stdenv
, fetchurl
, makeWrapper
, writeShellScript
, jre
}:

stdenv.mkDerivation rec {
  pname = "kroki-server";
  version = "0.17.0";

  src = fetchurl {
    url = "https://github.com/yuzutech/kroki/releases/download/v${version}/kroki-server-v${version}.jar";
    hash = "sha256-s+wLhKsdC5U/YQpzHRY9PdLsU94HxzkZU9ke3XJYQ6g=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/kroki-server \
      --add-flags "-jar ${src}"
  '';

  meta = with lib; {
    description = "Creates diagrams from textual descriptions";
    homepage = "https://github.com/yuzutech/kroki";
    license = licenses.mit;
    maintainers = with teams; iog.members;
    inherit (jre.meta) platforms;
  };
}


